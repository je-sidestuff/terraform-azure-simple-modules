resource "azurerm_resource_group" "state_resource_group" {
    name     = var.resource_group_name
    location = var.location
}

resource "azurerm_storage_account" "state_storage_account" {
    name                     = var.storage_account_name
    resource_group_name      = azurerm_resource_group.state_resource_group.name
    location                 = azurerm_resource_group.state_resource_group.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    tags = var.tags
}

resource "azurerm_storage_container" "state_container" {
    name                  = var.root_container_name
    storage_account_id    = azurerm_storage_account.state_storage_account.id
    container_access_type = "private"
}

resource "local_file" "terraform_backend" {
  count = (var.bootstrap_style == "terraform" && var.enable_remote) ? 1 : 0

  content  = templatefile("${path.module}/backend.tf.tmpl", {
    resource_group_name = azurerm_resource_group.state_resource_group.name
    storage_account_name = azurerm_storage_account.state_storage_account.name
    container_name = azurerm_storage_container.state_container.name
    state_key = "root.tfstate"
  })
  filename = "${path.root}/backend.tf"
}

resource "local_file" "terraform_backend_ignore" {
  count = (var.bootstrap_style == "terraform" && var.enable_remote) ? 1 : 0
  
  content  = "backend.tf"
  filename = "${path.root}/.gitignore"
}
