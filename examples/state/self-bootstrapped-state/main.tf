locals {
  naming_prefix = var.naming_prefix == "generate" ? "ex-${random_string.random.result}" : var.naming_prefix
  resource_group_name = "${local.naming_prefix}-rg"
  storage_account_name = "${replace(local.naming_prefix, "-", "")}sa"
  storage_container_name = "rootstate"
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

module "state" {
  source = "../../..//modules/state/self-bootstrapped-state"

  enable_remote = var.enable_remote

  resource_group_name  = local.resource_group_name
  location             = var.location
  storage_account_name = local.storage_account_name
  root_container_name  = local.storage_container_name

  bootstrap_styles = ["terraform", "terragrunt"]
  terragrunt_backend_generator_folder = "${path.root}/terragrunt-mock"

  tags = var.tags
}
