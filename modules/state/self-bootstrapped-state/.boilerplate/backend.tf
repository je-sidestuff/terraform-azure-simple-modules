terraform {

  backend "azurerm" {
    resource_group_name  = "{{ .ResourceGroupName }}"
    storage_account_name = "{{ .StorageAccountName }}"
    container_name       = "{{ .RootContainerName }}"
    key                  = "root.tfstate"
    }
}
