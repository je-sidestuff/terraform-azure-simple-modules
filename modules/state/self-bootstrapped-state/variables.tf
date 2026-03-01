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

variable "scoping_tags" {
  description = "A map of tags to apply to all resources using this state (including the resources here)."
  type        = map(string)
  default     = {}
}

variable "scoping_tags_include_random" {
  description = "Add a tag based on this storage account name and a random 4-character alphanumeric seed."
  type        = bool
  default     = true
}

variable "append_random_seed_to_storage_account_name" {
  description = "Append a random 4-character alphanumeric seed to the storage account name. Uses the same seed as scoping_tags_include_random when both are enabled."
  type        = bool
  default     = false
}

variable "scoping_tags_include_creation_timestamp" {
  description = "Add a tag to mark the creation time of this state's scope."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to apply to the resource."
  type        = map(string)
  default     = {}
}
