terraform {
  source = "{{ .sourceUrl }}"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/common.hcl"
  expose = true
}

include "backend" {
  path = find_in_parent_folders("backend-generator.hcl")
}

locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  location = local.region_vars.locals.region
}

inputs = {
  resource_group_name = "{{ .ResourceGroupName }}"
  naming_prefix = "{{ .NamingPrefix }}"
  location = local.location
  federated_identity_subjects = [{{range $i, $v := .FederatedIdentitySubjects}}{{if gt $i 0}}, {{end}}"{{$v}}"{{end}}]
  contributor_scope = "{{ .ContributorScope }}"
}
