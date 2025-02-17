output "name" {
  description = "Name of the container registry."
  value       = azurerm_container_registry.this.name
}

output "login_server" {
  description = "The login server of the container registry. (e.g. name.azurecr.io)"
  value       = azurerm_container_registry.this.login_server
}

output "admin_username" {
  description = "The name of the admin user."
  value       = azurerm_container_registry.this.admin_username
}

output "admin_password" {
  description = "The password of the admin user."
  value       = azurerm_container_registry.this.admin_password
  sensitive   = true
}
