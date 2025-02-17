output "id" {
  value       = azurerm_container_app.this.id
  description = "The ID of the container app."
}

output "name" {
  value       = local.full_name
  description = "The name of the container app."
}

output "latest_revision_fqdn" {
  value       = azurerm_container_app.this.latest_revision_fqdn
  description = "The fully qualified domain name of the most recent container app revision."
}

output "outbound_ip_addresses" {
  value       = azurerm_container_app.this.outbound_ip_addresses
  description = "A list of the outgoing IP addresses for this container app."
}
