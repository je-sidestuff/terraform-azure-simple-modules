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

inputs = {
  # Note that TF_VAR_github_pat must be present in the environment.
  name = "{{ .Name }}"
  init_payload_content = <<EOF
{{ .InitPayloadContent }}
EOF

  azure_subscription_id = dependency.mi.outputs.subscription_id
  azure_tenant_id       = dependency.mi.outputs.tenant_id
  azure_client_id       = dependency.mi.outputs.client_id

  timeout_in_seconds = {{ .TimeoutInSeconds }}
}
