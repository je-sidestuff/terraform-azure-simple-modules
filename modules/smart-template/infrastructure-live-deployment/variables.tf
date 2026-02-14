# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name for the repo to deploy from the smart template"
  type        = string
}

variable "github_pat" {
  description = "The personal access token used to authenticate for the runner-creation interactions."
  type        = string
  sensitive   = true
}

# Thesee guys should become optional in the future
variable "azure_subscription_id" {
  description = "The azure subscription id."
  type        = string
}

# Thesee guys should become optional in the future
variable "azure_tenant_id" {
  description = "The azure tenant id."
  type        = string
}

# Thesee guys should become optional in the future
variable "azure_client_id" {
  description = "The azure client id for the repo's managed identity."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "custom_actions_secrets" {
  description = "A map of custom actions secrets to add to the smart template repo."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "default_branch" {
  description = "Default branch of the deployed repo."
  type        = string
  default     = "main"
}

variable "description" {
  description = "Description of therepo created from the smart template."
  type        = string
  default     = "This infrastructure live repo was created from a smart template."
}

variable "infra_live_version" {
  description = "The version of azure infrastructure live template repo to use."
  type        = string
  default     = "v1"
}

variable "self_bootstrap_json" {
  description = "A json string used to scaffold the terragrunt tree that will be planned for consistency."
  type        = string
  # TODO - this needs a better default.
  default     = "{\"rg-name\": \"default-infra-live-rg\"}"
}

variable "self_bootstratp_json_in_base64" {
  description = "Whether the self-bootstrap json is supplied in base64."
  type = bool
  default = false
}

variable "deploy_json" {
  description = "A json string used to scaffold the terragrunt tree that will be deployed."
  type        = string
  # TODO - this needs a better default.
  default     = "{\"rg-name\": \"default-infra-live-rg\"}"
}

variable "deploy_json_in_base64" {
  description = "Whether the self-bootstrap json is supplied in base64."
  type = bool
  default = false
}

variable "state_backend" {
  description = "Values to be useed in the state backend generator."
  type        = object({
    resource_group_name = string
    storage_account_name = string
    container_name = string
    # Should we consider key name here in another increment?
  })
  default     = null # It won't actually accept null happily - TODO
}

variable "timeout_in_seconds" {
  description = "The number of seconds to allow for repo init."
  type        = number
  default     = 300
  validation {
    condition     = var.timeout_in_seconds > 19 && var.timeout_in_seconds < 3600
    error_message = "The timeout_in_seconds must be greater than 19 and less than 3600."
  }
}

variable "visibility" {
  description = "The visibility for the smart template repo to deploy. (public or private)"
  type        = string
  default     = "private"
  validation {
    condition     = contains(["public", "private"], var.visibility)
    error_message = "The visibility must be 'public' or 'private'."
  }
}