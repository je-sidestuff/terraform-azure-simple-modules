{{if .IncludeRoot}}
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# We add a gnerate here to work around the MI issue for now,
# But there must be a cleaner solution. (The root will skip, this will write)
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents = <<EOF
terraform {
  backend "azurerm" {
    resource_group_name  = "{{ .ResourceGroupName }}"
    storage_account_name = "{{ .StorageAccountName }}"
    container_name       = "{{ .RootContainerName }}"
    key                  = "root.tfstate"
    use_azuread_auth     = true
    use_oidc             = true
    }
}
EOF
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
