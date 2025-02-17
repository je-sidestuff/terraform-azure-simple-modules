# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "naming_prefix" {
  type        = string
  description = "A prefix to use for naming the Container Apps Environment."
}

variable "resource_group_name" {
  description = "The name of the resource group where the container will be deployed."
  type        = string
}

variable "location" {
  description = "The location where the container runtime will be deployed."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "naming_desc" {
  type        = string
  default     = ""
  description = "An abbreviated description string to differentiate naming of multiple resources."
}

variable "tags" {
  description = "Tags to be added to the container app environment."
  type        = map(string)
  default     = {}
}