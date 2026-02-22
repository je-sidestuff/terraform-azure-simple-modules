output "id" {
  value       = azurerm_resource_group.this.id
  description = "The ID of the Resource Group."
}

output "name" {
  value       = local.full_name
  description = "The name of the Resource Group."
}

output "location" {
  value       = azurerm_resource_group.this.location
  description = "The location of the Resource Group."
}
