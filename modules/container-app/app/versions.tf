terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.4"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.51.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2"
    }
  }
  required_version = ">= 1.4.0"
}
