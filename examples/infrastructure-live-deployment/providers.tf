terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "github" {
  token = var.github_pat
  # Note that an org is necessary because the provider malfunctions if the
  # owner is a user. (TODO - get issue number for provider)
  owner = var.github_org
}
