terraform {
  source = "{{ .sourceUrl }}"
}

include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/common.hcl"
  expose = true
}

inputs = {
  resource_group_name = "{{ .ResourceGroupName }}"
  storage_account_name = replace("{{ .Name }}", "-", "")
  container_names = [replace("{{ .Name }}", "-", "")]
}
