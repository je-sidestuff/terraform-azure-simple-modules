# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "github_pat" {
  description = "The personal access token used to authenticate for the runner-creation interactions."
  type        = string
  sensitive   = true
}

variable "github_org" {
  description = "The organization which you are logging in on behalf of. TODO this is currently mandatory because of a provider bug."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "location" {
  description = "The location where the container runtime will be deployed."
  type        = string
  default     = "eastus"
}

variable "name" {
  description = "The name of the repository we will create from this template."
  type        = string
  default     = "generate"
}

variable "init_payload_content" {
  description = "A json string uused to drive the initialization of the repo."
  type        = string
  default     = "{\"filename\": \"INITIALIZED\"}"
}
