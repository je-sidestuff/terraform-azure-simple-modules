# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "naming_prefix" {
  type        = string
  description = "Prefix to use for naming the Container App."
}

variable "location" {
  description = "The location where the managed identity will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the container app will be deployed."
  type        = string
}

variable "federated_identity_subjects" {
  description = "The list of federated identity subjects to add to the managed identity."
  type        = list(string)
}

variable "contributor_scope" {
  description = "The scope at which the managed identity will have contributor permissions assigned."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "naming_desc" {
  type        = string
  default     = ""
  description = "Abbreviated description string to differentiate naming of multiple resources."
}

variable "tags" {
  description = "Tags to be added to the full container group."
  type        = map(string)
  default     = {}
}
