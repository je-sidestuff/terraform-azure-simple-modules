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
  default     = <<EOF
{
  "self_bootstrap" : {
    "subscription_id" : "26b5518a-2387-4baa-8089-813227c5e476",
    "input_targets" : {
      "storage_account" : {
        "repo": "je-sidestuff/terraform-azure-simple-modules",
        "path": "modules/data-stores/storage-account",
        "branch": "environment_deployment_support",
        "placement": {
          "region": "eastus",
          "env": "default",
          "subscription": "sandbox"
        },
        "vars": {
          "ResourceGroupName": "from-infra-live-example",
          "Name": "iiliveexstorageaccount",
          "CreateResourceGroup": "true",
          "Location": "eastus"
        }
      }
    }
  }
}
EOF
}
