output "client_id" {
  value = azurerm_user_assigned_identity.this.client_id
}

# This is a temporary inclusion, it should not be necessary here.
data "azurerm_client_config" "current" {}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}