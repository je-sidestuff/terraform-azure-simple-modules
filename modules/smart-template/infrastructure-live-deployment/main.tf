locals {
  init_payload_content = jsondecode(var.init_payload_content)
  init_payload = jsonencode(merge(
    local.init_payload_content,
    {
      "state" = {
        a = "b"
        c = "d"
      }
    }
  ))
}

module "this" {
  source = "github.com/je-sidestuff/terraform-github-orchestration.git//modules/repos/smart-template/deployment?ref=environment_deployment_support"

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

  timeout_in_seconds   = var.timeout_in_seconds
  source_owner         = "je-sidestuff"
  template_repo_name   = "azure-infrastructure-live-template"
}

resource "time_sleep" "wait_10s_to_push_workflow" {
  create_duration = "10s"

  depends_on = [module.this]
}

data "local_file" "workflow" {
  filename = "${path.module}/deploy_workflow.yaml"
}

resource "github_repository_file" "workflow" {
  repository          = var.name
  branch              = "main"
  file                = ".github/workflows/deploy_workflow.yaml"
  content             = data.local_file.workflow.content
  commit_message      = "Managed by ${var.name}"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true

  depends_on = [time_sleep.wait_10s_to_push_workflow]
}