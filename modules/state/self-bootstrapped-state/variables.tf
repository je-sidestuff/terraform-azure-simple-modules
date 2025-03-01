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

variable "bootstrap_style" {
  description = "To use this module for a direct tofu/terraform bootstrap or a terragrunt bootstrap."
  type        = string
  default     = "terraform"
  validation {
    condition     = contains(["terraform", "terragrunt"], var.bootstrap_style)
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

variable "tags" {
  description = "A map of tags to apply to the resource."
  type        = map(string)
  default     = {}
}
