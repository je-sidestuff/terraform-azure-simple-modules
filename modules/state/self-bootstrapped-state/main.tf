resource "random_string" "scope_seed" {
  count   = var.scoping_tags_include_random ? 1 : 0
  length  = 4
  special = false
  upper   = false
}

resource "time_static" "scope_creation" {
  count = var.scoping_tags_include_creation_timestamp ? 1 : 0
}

locals {
  random_tag = var.scoping_tags_include_random ? {
    "state-seed" = "${var.storage_account_name}-${random_string.scope_seed[0].result}"
  } : {}

  timestamp_tag = var.scoping_tags_include_creation_timestamp ? {
    "state-created" = time_static.scope_creation[0].rfc3339
  } : {}

  scoping_tags = merge(
    var.scoping_tags,
    local.random_tag,
    local.timestamp_tag
  )

  all_tags = merge(local.scoping_tags, var.tags)
}

resource "azurerm_resource_group" "state_resource_group" {
    name     = var.resource_group_name
    location = var.location
    tags     = local.all_tags
}

resource "azurerm_storage_account" "state_storage_account" {
    name                     = var.storage_account_name
    resource_group_name      = azurerm_resource_group.state_resource_group.name
    location                 = azurerm_resource_group.state_resource_group.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    tags = local.all_tags
}

resource "azurerm_storage_container" "state_container" {
    name                  = var.root_container_name
    storage_account_id    = azurerm_storage_account.state_storage_account.id
    container_access_type = "private"
}

resource "local_file" "terraform_backend" {
  count = (contains(var.bootstrap_styles, "terraform") && var.enable_remote) ? 1 : 0

  content  = templatefile("${path.module}/backend.tf.tmpl", {
    resource_group_name = azurerm_resource_group.state_resource_group.name
    storage_account_name = azurerm_storage_account.state_storage_account.name
    container_name = azurerm_storage_container.state_container.name
    state_key = "root.tfstate"
  })
  filename = "${path.root}/backend.tf"
}

resource "local_file" "terragrunt_generator" {
  count = (contains(var.bootstrap_styles, "terragrunt") && var.enable_remote) ? 1 : 0

  content  = templatefile("${path.module}/backend-generator.hcl.tmpl", {
    resource_group = azurerm_resource_group.state_resource_group.name
    storage_account = azurerm_storage_account.state_storage_account.name
    container = azurerm_storage_container.state_container.name
    key_string = "${"$"}{path_relative_to_include()}/terraform.tfstate"
  })
  filename = "${var.terragrunt_backend_generator_folder}/backend-generator.hcl"

  lifecycle {
    precondition {
      condition     = var.terragrunt_backend_generator_folder != ""
      error_message = "The terragrunt_backend_generator_folder must be set if bootstrap_style includes terragrunt"
    }
  }
}
