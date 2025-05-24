inputs = {
  resource_group_name = "{{ .ResourceGroupName }}"
  storage_account_name = "{{ .StorageAccountName }}"
  root_container_name = "{{ .RootContainerName }}"

  bootstrap_styles = ["terraform", "terragrunt"]
}

prevent_destroy = true
