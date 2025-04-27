locals {
  name_suffix = var.naming_desc == "" ? "-mi" : "-mi-${var.naming_desc}"
  full_name   = "${var.naming_prefix}${local.name_suffix}"
}

resource "azurerm_user_assigned_identity" "this" {
  name                = local.full_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_federated_identity_credential" "this" {
  for_each = toset(var.federated_identity_subjects)

  name                = "${local.full_name}-${substr(sha256(each.key), 0, 8)}"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.this.id
  subject             = each.key # "repo:${github_repository.example.full_name}:environment:dev"
}

resource "azurerm_role_assignment" "this" {
   scope                = var.contributor_scope
   role_definition_name = "Contributor"
   principal_id         = azurerm_user_assigned_identity.this.principal_id
}

resource "azurerm_role_assignment" "storage_account_data" {
   scope                = var.contributor_scope
   role_definition_name = "Storage Blob Data Contributor"
   principal_id         = azurerm_user_assigned_identity.this.principal_id
}
