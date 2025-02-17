# Azure Container Apps Environment

This module is used to create a container app environment. This includes the environment itself and the associated log analytics workspace.

## Purpose

The purpose of this module is to provide a simple way to create a container app environment. This is useful for testing and development purposes.

## Prerequisites

Before using this module you will need to have the Azure CLI installed and configured on your machine.

## Inputs

This module requires the following inputs:

* `naming_prefix`: A prefix to use for naming the container app environment.
* `resource_group_name`: The name of the resource group where the container app environment will be deployed.
* `location`: The location where the container app environment will be deployed.

The following inputs are also optional:

* `naming_desc`: An abbreviated description string to differentiate naming of multiple resources.
* `tags`: Tags to be added to the container app environment.

