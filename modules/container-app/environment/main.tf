locals {
  name_suffix = var.naming_desc == "" ? "-cae" : "-cae-${var.naming_desc}"
  full_name   = "${var.naming_prefix}${local.name_suffix}"

  law_suffix = var.naming_desc == "" ? "-law" : "-law-${var.naming_desc}"
  law_name   = "${var.naming_prefix}${local.law_suffix}"
}

resource "azurerm_container_app_environment" "this" {
  name                       = local.full_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  tags = var.tags
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = local.law_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
