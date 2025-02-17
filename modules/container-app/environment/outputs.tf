output "id" {
  value       = azurerm_container_app_environment.this.id
  description = "The ID of the container app environment."
}

output "default_domain" {
  value       = azurerm_container_app_environment.this.default_domain
  description = "The default domain of the container app environment."
}

output "static_ip" {
  value       = azurerm_container_app_environment.this.static_ip_address
  description = "The static IP of the container app environment."
}

output "name" {
  value       = local.full_name
  description = "The name of the container app environment."
}

output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.this.id
  description = "The ID of the log analytics workspace."
}

output "log_analytics_workspace_name" {
  value       = azurerm_log_analytics_workspace.this.name
  description = "The name of the log analytics workspace."
}
