locals {
  name_prefix  = var.name == "generate" ? "ex-${random_string.random.result}" : var.name
  example_repo = "${local.name_prefix}-repo"
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "this" {
  name     = "${local.name_prefix}-rg"
  location = var.location
}

module "managed_identity" {
  source = "../..//modules/iam/managed-identity"

  naming_prefix       = local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  federated_identity_subjects = [
    "repo:${var.github_org}/${local.example_repo}:ref:refs/heads/main"
  ]

  contributor_scope = azurerm_resource_group.this.id
}

module "repo" {
  source = "../..//modules/smart-template/infrastructure-live-deployment"

  name                 = local.example_repo
  github_pat           = var.github_pat
  init_payload_content = var.init_payload_content
}

resource "local_file" "workflow" {
  content = templatefile(
    "${path.module}/test_workflow.yaml.tmpl",
    {
      "example_name"    = local.name_prefix
      "client_id"       = module.managed_identity.client_id
      "tenant_id"       = data.azurerm_client_config.current.tenant_id
      "subscription_id" = data.azurerm_client_config.current.subscription_id
    }
  )
  filename = "${path.module}/test_workflow.yaml"
}

resource "time_sleep" "wait_10s_to_push_workflow" {
  create_duration = "10s"

  depends_on = [module.repo]
}

resource "github_repository_file" "workflow" {
  repository          = local.example_repo
  branch              = "main"
  file                = ".github/workflows/test_workflow.yaml"
  content             = local_file.workflow.content
  commit_message      = "Managed by example ${local.name_prefix}"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true

  depends_on = [time_sleep.wait_10s_to_push_workflow]
}
