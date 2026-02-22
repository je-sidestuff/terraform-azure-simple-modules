# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "naming_prefix" {
  type        = string
  description = "Prefix to use for naming the Resource Group."
}

variable "location" {
  type        = string
  description = "The Azure region where the Resource Group should be created."
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
  description = "Tags to be added to the Resource Group."
  type        = map(string)
  default     = {}
}
