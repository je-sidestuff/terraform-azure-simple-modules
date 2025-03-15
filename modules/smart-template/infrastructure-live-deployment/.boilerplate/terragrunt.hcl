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

inputs = {
  # Note that TF_VAR_github_pat must be present in the environment.
  name = "{{ .Name }}"
  init_payload_content = <<EOF
{{ .InitPayloadContent }}
EOF
}
