locals {
  naming_prefix = var.naming_prefix == "generate" ? "ex-${random_string.random.result}" : var.naming_prefix
}

data "azurerm_client_config" "current" {}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "this" {
  name     = "${local.naming_prefix}-rg"
  location = var.location
}

module "acr" {
  source = "../../../modules/azure-container-registry/registry"

  naming_prefix       = local.naming_prefix
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "local_file" "index_html" {
  content = var.hosted_message
  filename = "${path.root}/app/static/index.html"
}

module "image_build" {
  source = "../../../modules/azure-container-registry/image-build"

  acr_name        = module.acr.name
  subscription_id = data.azurerm_client_config.current.subscription_id
  image_name      = "my-webapp"
  image_tag       = "v0.0.1"
  docker_context  = "${path.root}/app"

  depends_on = [local_file.index_html]
}

module "container_app_environment" {
  source = "../../../modules/container-app/environment"

  naming_prefix       = local.naming_prefix
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = var.tags
}

module "webapp_aca" {
  source = "../../../modules/container-app/app"

  naming_prefix                = local.naming_prefix
  naming_desc                  = "webapp"
  resource_group_name          = azurerm_resource_group.this.name
  managed_environment_id       = module.container_app_environment.id
  min_replicas                 = 1
  max_replicas                 = 1
  use_system_assigned_identity = true

  tags = {}

  ingress = {
    target_port = 8080
    external    = true
    transport   = "http"
  }

  password_protected_registries = {
    (module.acr.login_server) = {
      admin_username = module.acr.admin_username
      admin_password = module.acr.admin_password
    }
  }

  containers = {
    nginx = {
      image  = module.image_build.image_name
      cpu    = 1
      memory = "2Gi"
    }
  }

  use_azapi_for_extras = false
}
