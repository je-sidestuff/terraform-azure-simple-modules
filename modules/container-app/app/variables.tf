# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "naming_prefix" {
  type        = string
  description = "Prefix to use for naming the Container App."
}

variable "naming_desc" {
  type        = string
  default     = ""
  description = "Abbreviated description string to differentiate naming of multiple resources."
}

variable "resource_group_name" {
  description = "The name of the resource group where the container app will be deployed."
  type        = string
}

variable "managed_environment_id" {
  description = "The ID of the container app environment where this container app is to run."
  type        = string
}

variable "min_replicas" {
  description = "The minimum number of container sets to run. The full collection of containers will be scaled together."
  type        = number
}

variable "max_replicas" {
  description = "The maximum number of container sets to run. The full collection of containers will be scaled together."
  type        = number
}

variable "containers" {
  type = map(object({
    args                   = optional(list(string), [])
    command                = optional(list(string), [])
    image                  = string
    cpu                    = number
    memory                 = string
    storage                = optional(string)
    environment_variables  = optional(map(string), {})
    referenced_secret_envs = optional(map(string), {})
    volume = optional(map(object({
      name       = optional(string, null)
      mount_path = optional(string, null)
    })), {})
    liveness_probe = optional(object({
      failure_threshold                = optional(number)
      http_headers                     = optional(map(string), {})
      host                             = optional(string)
      initial_delay_seconds            = optional(number)
      interval_seconds                 = optional(number)
      path                             = optional(string)
      port                             = number
      termination_grace_period_seconds = optional(number)
      timeout_seconds                  = optional(number)
      transport                        = string
    }))
    readiness_probe = optional(object({
      failure_threshold       = optional(number)
      http_headers            = optional(map(string), {})
      host                    = optional(string)
      interval_seconds        = optional(number)
      path                    = optional(string)
      port                    = number
      success_count_threshold = optional(number)
      timeout_seconds         = optional(number)
      transport               = string
    }))
    startup_probe = optional(object({
      failure_threshold                = optional(number)
      http_headers                     = optional(map(string), {})
      host                             = optional(string)
      interval_seconds                 = optional(number)
      path                             = optional(string)
      port                             = number
      termination_grace_period_seconds = optional(number)
      timeout_seconds                  = optional(number)
      transport                        = string
    }))
  }))

  description = <<-EOF
    A map of containers to run at steady state in the container app. Container name is the key.

    Example:
    nginx = {
      image     = "nginx"
      cpu       = 0.5
      memory    = "1Gi"
      http_readiness_probe = {
        http_get = {
          path = "/"
          port = 80
        }
      }
      http_liveness_probe = {
        http_get = {
          path = "/"
          port = 80
        }
      }
    }

    The 'referenced_secret_envs' attribute takes the form where the key is the name of the environment variable and
    the name value is the name of the secret defined int var.secrets.
    EOF
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "use_system_assigned_identity" {
  description = "Whether to assign a system assigned managed identity to this container group."
  type        = bool
  default     = false
}

variable "user_assigned_identity_ids" {
  description = "A list of the IDs of user assigned identities to assign this container group."
  type        = list(string)
  default     = []
}

variable "ingress" {
  description = "A block describing the ingress behaviour for this container app."
  type = object({
    allow_insecure = optional(bool, false)
    external       = optional(bool, false)
    target_port    = number
    transport      = optional(string)
  })
  default = null
}

variable "volume" {
  description = "An object describing the storage to make available to the container app"
  type = map(object({
    storage_name = optional(string, null)
    storage_type = optional(string, "EmptyDir")
  }))
  validation {
    condition = alltrue([for k, v in var.volume :
      contains([
        "AzureFile",
        "EmptyDir"
      ], v.storage_type)
    ])
    error_message = "Acceptable values for 'storage_type' are 'AzureFile' and 'EmptyDir'."
  }
  default = {}
}

variable "password_protected_registries" {
  description = "A map of ACR servers accessed with passwords. Keys are the login server names."
  type = map(object({
    admin_password = string
    admin_username = string
  }))
  sensitive = true
  default   = {}
}

variable "identity_protected_registries" {
  description = "A map of ACR servers to user assigned identity IDs. Keys are the login server names."
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "A map of secret names to secret values. Containers reference these secrets using 'referenced_secret_envs' field."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "replacement_triggers" {
  type        = list(string)
  default     = []
  description = "List of values which will trigger a replacement of the app service if changed."
}

variable "tags" {
  description = "Tags to be added to the full container group."
  type        = map(string)
  default     = {}
}

variable "ipSecurityRestrictions" {
  description = "A block describing the IP-based access restriction behaviour for this container app."
  type = list(object({
    rule-name      = string
    description    = optional(string, "")
    ipAddressRange = string
    action         = string
  }))
  default = []
  validation {
    condition = alltrue(concat(
      [
        for v in var.ipSecurityRestrictions : contains([
          "Allow",
          "Deny"
        ], v.action)
      ],
      [
        for v in var.ipSecurityRestrictions : can(regex(
          "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(/?)(([0-9]|[1-2][0-9]|3[0-2]))?$", v.ipAddressRange
        ))
      ]
    ))
    error_message = "Default action must be 'Allow' or 'Deny'. IP value must be a CIDR."
  }
}
