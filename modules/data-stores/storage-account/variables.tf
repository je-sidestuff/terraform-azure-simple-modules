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

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "container_names" {
  description = "The names of the storage containers."
  type        = list(string)
  default     = []
}

variable "create_resource_group" {
  description = "Whether to create the resource group. (Will be assumed to exist if false.)"
  type        = bool
  default     = false
}

variable "location" {
  description = "The location where the storage account will be deployed. Required, and only used, if create_resource_group is true."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to apply to the resource."
  type        = map(string)
  default     = {}
}
