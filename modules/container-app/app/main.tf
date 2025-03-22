locals {
  # Determine whether identity is '' | 'SystemAssigned' | 'UserAssigned' -- 'SystemAssigned, UserAssigned' is invalid for ACA
  user_id_used         = length(var.user_assigned_identity_ids) > 0
  sys_and_user_id_used = var.use_system_assigned_identity && local.user_id_used

  assigned_identity_type = (local.sys_and_user_id_used ?
    "Invalid" : var.use_system_assigned_identity ?
    "SystemAssigned" : local.user_id_used ?
    "UserAssigned" :
    null
  )

  name_suffix = var.naming_desc == "" ? "-ca" : "-ca-${var.naming_desc}"
  full_name   = "${var.naming_prefix}${local.name_suffix}"
}

resource "terraform_data" "replacement_triggers" {
  triggers_replace = {
    for idx, trigger in var.replacement_triggers :
    "trigger${idx}" => trigger
  }
}

resource "azurerm_container_app" "this" {
  name                         = local.full_name
  container_app_environment_id = var.managed_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    dynamic "container" {
      for_each = var.containers

      content {
        name              = container.key
        image             = container.value.image
        cpu               = container.value.cpu
        memory            = container.value.memory
        args              = container.value.args
        command           = container.value.command
        ephemeral_storage = container.value.storage

        dynamic "env" {
          for_each = container.value.environment_variables

          content {
            name  = env.key
            value = env.value
          }
        }

        dynamic "env" {
          for_each = container.value.referenced_secret_envs

          content {
            name        = env.key
            secret_name = env.value
          }
        }

        dynamic "volume_mounts" {
          for_each = container.value.volume
          content {
            name = volume_mounts.value.name
            path = volume_mounts.value.mount_path
          }
        }

        dynamic "liveness_probe" {
          for_each = container.value.liveness_probe != null ? [container.value.liveness_probe] : []

          content {
            failure_count_threshold = liveness_probe.value.failure_threshold

            dynamic "header" {
              for_each = liveness_probe.value.http_headers

              content {
                name  = header.key
                value = header.value
              }
            }

            host                             = liveness_probe.value.host
            initial_delay                    = liveness_probe.value.initial_delay_seconds
            interval_seconds                 = liveness_probe.value.interval_seconds
            path                             = liveness_probe.value.path
            port                             = liveness_probe.value.port
            termination_grace_period_seconds = liveness_probe.value.termination_grace_period_seconds
            timeout                          = liveness_probe.value.timeout_seconds
            transport                        = liveness_probe.value.transport
          }
        }

        dynamic "readiness_probe" {
          for_each = container.value.readiness_probe != null ? [container.value.readiness_probe] : []

          content {
            failure_count_threshold = readiness_probe.value.failure_threshold

            dynamic "header" {
              for_each = readiness_probe.value.http_headers

              content {
                name  = header.key
                value = header.value
              }
            }

            host                    = readiness_probe.value.host
            interval_seconds        = readiness_probe.value.interval_seconds
            path                    = readiness_probe.value.path
            port                    = readiness_probe.value.port
            success_count_threshold = readiness_probe.value.success_count_threshold
            timeout                 = readiness_probe.value.timeout_seconds
            transport               = readiness_probe.value.transport
          }
        }

        dynamic "startup_probe" {
          for_each = container.value.startup_probe != null ? [container.value.startup_probe] : []

          content {
            failure_count_threshold = startup_probe.value.failure_threshold

            dynamic "header" {
              for_each = startup_probe.value.http_headers

              content {
                name  = header.key
                value = header.value
              }
            }

            host                             = startup_probe.value.host
            interval_seconds                 = startup_probe.value.interval_seconds
            path                             = startup_probe.value.path
            port                             = startup_probe.value.port
            termination_grace_period_seconds = startup_probe.value.termination_grace_period_seconds
            timeout                          = startup_probe.value.timeout_seconds
            transport                        = startup_probe.value.transport
          }
        }
      }
    }

    dynamic "volume" {
      for_each = var.volume
      content {
        name         = volume.key
        storage_name = volume.value.storage_name
        storage_type = volume.value.storage_type
      }
    }

    max_replicas = var.max_replicas
    min_replicas = var.min_replicas
  }

  dynamic "identity" {
    for_each = local.assigned_identity_type != null ? [1] : []

    content {
      type         = local.assigned_identity_type
      identity_ids = var.user_assigned_identity_ids
    }
  }
  
  dynamic "ingress" {
    for_each = var.ingress != null ? [1] : []

    content {
      external_enabled = var.ingress.external
      target_port      = var.ingress.target_port
      traffic_weight {
        percentage = 100
        latest_revision = true
      }
      transport        = var.ingress.transport
    }
  }


  dynamic "registry" {
    for_each = nonsensitive(var.password_protected_registries)

    content {
      # This secret name is in the form which github actions expects by default
      password_secret_name = "${lower(registry.value.admin_username)}azurecrio-${lower(registry.value.admin_username)}"
      server               = registry.key
      username             = registry.value.admin_username
    }
  }

  dynamic "registry" {
    for_each = var.identity_protected_registries

    content {
      server   = registry.key
      identity = registry.value
    }
  }

  dynamic "secret" {
    for_each = nonsensitive(var.secrets)

    content {
      name  = secret.key
      value = secret.value
    }
  }

  dynamic "secret" {
    for_each = nonsensitive(var.password_protected_registries)

    content {
      name  = "${lower(secret.value.admin_username)}azurecrio-${lower(secret.value.admin_username)}"
      value = secret.value.admin_password
    }
  }

  tags = var.tags

  # We must ignore changes which have been created through the AzApi update
  lifecycle {
    replace_triggered_by = [terraform_data.replacement_triggers]

    ignore_changes = [
      ingress,
      identity
    ]
    precondition {
      condition     = local.assigned_identity_type != "Invalid"
      error_message = "Azure Container Apps only allow user assigned OR system assigned MSI - not both."
    }
    precondition {
      condition = alltrue([
        for k, v in var.identity_protected_registries : contains(var.user_assigned_identity_ids, v)
      ])
      error_message = "Identity Protected Registries must leverage a User Assigned Identity which is assigned to this ACA."
    }
  }
}

resource "azapi_update_resource" "add_extras_to_container_app" {
  count = var.use_azapi_for_extras ? 1 : 0

  type        = "Microsoft.App/containerApps@2022-06-01-preview"
  resource_id = azurerm_container_app.this.id

  body = jsonencode({
    properties : {
      configuration = {
        ingress = (var.ingress == null ? null :
          {
            external               = var.ingress.external
            targetPort             = var.ingress.target_port
            transport              = var.ingress.transport
            allowInsecure          = var.ingress.allow_insecure
            ipSecurityRestrictions = var.ipSecurityRestrictions
        })
        # We must include the secrets again or else the update will fail due to the Azure REST API
        secrets = concat([
          for name, value in var.secrets :
          {
            name  = name
            value = value
          }
          ],
          [
            for registry_credentials in var.password_protected_registries :
            {
              name  = "${lower(registry_credentials.admin_username)}azurecrio-${lower(registry_credentials.admin_username)}"
              value = registry_credentials.admin_password
            }
        ])
      }
    }
  })

  # We must ignore changes to the body of the request as AzApi provider cannot correctly compare current resource
  # state to new request content
  lifecycle {
    replace_triggered_by = [terraform_data.replacement_triggers]

    ignore_changes = [
      body
    ]
  }

  depends_on = [
    azurerm_container_app.this,
  ]
}
