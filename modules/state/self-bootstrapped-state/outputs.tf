output "container_name" {
  description = "The name of the state's storage container."
  value = azurerm_storage_container.state_container.name
}

output "migrate_state_command" {
  description = "The command to migrate state to the new storage account."
  value = "terraform init -input=false -migrate-state -force-copy"
}

output "resource_group_name" {
  description = "The name of the resource group where the state storage will be deployed."
  value = azurerm_resource_group.state_resource_group.name
}

output "storage_account_name" {
  description = "The name of the storage account where the state storage will be deployed."
  value = azurerm_storage_account.state_storage_account.name
}

output "terragrunt_backend_generator" {
  value = templatefile("${path.module}/backend-generator.hcl.tmpl", {
    resource_group = azurerm_resource_group.state_resource_group.name
    storage_account = azurerm_storage_account.state_storage_account.name
    container = azurerm_storage_container.state_container.name
    key_string = "${"$"}{path_relative_to_include()}/terraform.tfstate"
  })
}
