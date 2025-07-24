terraform {
  source = "{{ .sourceUrl }}"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "backend" {
  path = find_in_parent_folders("backend-generator.hcl")
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/common.hcl"
  expose = true
}

generate "github_provider" {
  path      = "github_provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "github" {
  token = var.github_pat
  # Note that an org is necessary because the provider malfunctions if the
  # owner is a user. (TODO - get issue number for provider)
  owner = "{{ .GithubOrg }}"
}
EOF
}

dependency "mi" {
  config_path = "../../iam/managed_identity"
}

dependency "state" {
  config_path = "../../state/self_bootstrapped_state"
}

inputs = {

  # Note that TF_VAR_github_pat must be present in the environment.
  name = "{{ .Name }}"

  self_bootstrap_json = "{{ .SelfBootstrapContentJsonB64 }}"

  self_bootstratp_json_in_base64 = true

  deploy_json = "{{ .DeployContentJsonB64 }}"

  deploy_json_in_base64 = true

  state_backend = {
    resource_group_name = dependency.state.outputs.resource_group_name
    storage_account_name = dependency.state.outputs.storage_account_name
    container_name = dependency.state.outputs.container_name
  }

  azure_subscription_id = dependency.mi.outputs.subscription_id
  azure_tenant_id       = dependency.mi.outputs.tenant_id
  azure_client_id       = dependency.mi.outputs.client_id

  timeout_in_seconds = {{ .TimeoutInSeconds }}
}
