{{if .IncludeRoot}}
include "root" {
  path = find_in_parent_folders("root.hcl")
}
{{end}}

inputs = {
  resource_group_name = "{{ .ResourceGroupName }}"
  storage_account_name = "{{ .StorageAccountName }}"
  root_container_name = "{{ .RootContainerName }}"

  bootstrap_styles = ["terraform", "terragrunt"]
}

# We exclude destruction because we must migrate the state locally first with the script
exclude {
    if = true
    actions = ["destroy"]
}

prevent_destroy = true
