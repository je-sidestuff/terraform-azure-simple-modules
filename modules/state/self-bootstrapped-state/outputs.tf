output "migrate_state_command" {
    description = "The command to migrate state to the new storage account."
  value = "terraform init -input=false -migrate-state -force-copy"
}

output "terragrunt_backend_generator" {
  value = templatefile("${path.module}/backend-generator.hcl.tmpl", {
    resource_group = azurerm_resource_group.state_resource_group.name
    storage_account = azurerm_storage_account.state_storage_account.name
    container = azurerm_storage_container.state_container.name
    key_string = "${"$"}{path_relative_to_include()}/terraform.tfstate"
  })
}
