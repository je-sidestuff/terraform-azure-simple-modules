locals {
  # Remove and hyphens and make prefix all-lowercase
  naming_prefix = lower(replace(var.naming_prefix, "-", ""))
  naming_desc   = lower(replace(var.naming_desc, "-", ""))
}

resource "azurerm_container_registry" "this" {
  name                = "${local.naming_prefix}acr${local.naming_desc}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"
  admin_enabled       = true

  tags = var.tags
}
