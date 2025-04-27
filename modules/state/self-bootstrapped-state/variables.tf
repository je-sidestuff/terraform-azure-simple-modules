# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "resource_group_name" {
  description = "The name of the resource group where the state storage will be deployed."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the state storage account."
  type        = string
}

variable "root_container_name" {
  description = "The name of the state storage container where the state for the state storage will be stored."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "bootstrap_styles" {
  description = "To use this module for a direct tofu/terraform bootstrap or a terragrunt bootstrap."
  type        = list(string)
  default     = ["terraform"]
  validation {
    condition     = alltrue([for v in var.bootstrap_styles : contains(["terraform", "terragrunt"], v)])
    error_message = "Acceptable values for 'bootstrap_style' are 'terraform' and 'terragrunt'."
  }
}

variable "enable_remote" {
  description = "The current configuration for the module to use. By first setting this to false and applying we can safely destroy."
  type        = bool
  default     = true
}

variable "location" {
  description = "The location where the state storage will be deployed."
  type        = string
  default     = "eastus"
}

variable "terragrunt_backend_generator_folder" {
  description = "The path to the folder where the terragrunt backend generator will be deployed. Only used if bootstrap_style includes terragrunt."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to apply to the resource."
  type        = map(string)
  default     = {}
}
