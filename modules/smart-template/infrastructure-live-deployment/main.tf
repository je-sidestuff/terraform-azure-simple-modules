module "this" {
  source = "git@github.com:je-sidestuff/terraform-github-orchestration.git//modules/repos/smart-template/deployment?ref=environment_deployment_support"

  name                   = var.name
  github_pat             = var.github_pat
  init_payload_content   = var.init_payload_content
  default_branch         = var.default_branch
  description            = var.description
  visibility             = var.visibility
  custom_actions_secrets = { # Note that these values are not actually secret, but they are 'username' equivalent sensitivity.
    AZURE_SUBSCRIPTION_ID = var.azure_subscription_id
    AZURE_TENANT_ID       = var.azure_tenant_id
    AZURE_MI_CLIENT_ID    = var.azure_client_id
  }

  source_owner         = "je-sidestuff"
  template_repo_name   = "azure-infrastructure-live-template"
}
