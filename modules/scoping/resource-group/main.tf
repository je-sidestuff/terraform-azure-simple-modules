locals {
  name_suffix = var.naming_desc == "" ? "-rg" : "-rg-${var.naming_desc}"
  full_name   = "${var.naming_prefix}${local.name_suffix}"
}

resource "azurerm_resource_group" "this" {
  name     = local.full_name
  location = var.location
  tags     = var.tags
}
