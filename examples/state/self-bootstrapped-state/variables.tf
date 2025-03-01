# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

# Nope!

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "enable_remote" {
  description = "The current configuration for the module to use. By first setting this to false and applying we can safely destroy."
  type        = bool
  default     = true
}

variable "location" {
  description = "The location where the container runtime will be deployed."
  type        = string
  default     = "eastus"
}

variable "naming_prefix" {
  type        = string
  description = "A prefix to use for naming the Container Apps Environment."
  default     = "generate"
}

variable "tags" {
  description = "Tags to be added to the container app environment."
  type        = map(string)
  default     = {}
}
