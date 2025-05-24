module "state" {

  source = "{{ .sourceUrl }}"

  enable_remote = var.enable_remote

  resource_group_name  = "{{ .ResourceGroupName }}"
  storage_account_name = "{{ .StorageAccountName }}"
  root_container_name  = "{{ .RootContainerName }}"


  # tags = var.tags TODO - we probably want tags
}
