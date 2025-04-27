#!/bin/bash

# This script executes the multi-phase process of self-bootstrapping.
# It first applies the module with the assumption thati t has not yet been applied, and then runs the migration command.
# It then plans again to verify no changes.

terraform init -input=false
terraform apply --auto-approve
terraform init -input=false -migrate-state -force-copy
terraform plan
