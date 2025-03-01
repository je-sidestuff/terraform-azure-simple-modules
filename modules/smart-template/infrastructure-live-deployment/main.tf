
module "this" {
  source = "git@github.com:je-sidestuff/terraform-github-orchestration.git//modules/repos/smart-template/deployment"

  name                 = var.name
  github_pat           = var.github_pat
  init_payload_content = var.init_payload_content
  default_branch       = var.default_branch
  description          = var.description
  visibility           = var.visibility

  source_owner         = "je-sidestuff"
  template_repo_name   = "azure-infrastructure-live-template"
}
