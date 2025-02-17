# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "acr_name" {
  type        = string
  description = "The name of the Azure Container Registry where the image will be built."
}

variable "subscription_id" {
  description = "The ID of the subscription where the ACR exists."
  type        = string
}

variable "image_name" {
  description = "The name of the image to build."
  type        = string
}

variable "image_tag" {
  description = "The tag of the image to build."
  type        = string
}

variable "docker_context" {
  description = "The path to the directory containing the Dockerfile."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

# Nope!
