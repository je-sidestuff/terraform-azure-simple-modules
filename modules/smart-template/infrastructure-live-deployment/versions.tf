terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.20.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.5.0"
    }
  }
  required_version = ">= 1.4.0"
}
