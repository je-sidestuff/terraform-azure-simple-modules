#!/bin/bash

# This script executes the multi-phase process of self-bootstrapping.
# It first applies the module with the assumption that it has not yet been applied, and then runs the migration command.
# It then plans again to verify no changes.

# We also delete the backend file if it already exists - this is necessary
# for the terragrunt-based process where we want the state to be scaffolded in a remote configuration in some cases.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [ -f "${SCRIPT_DIR}/backend.tf" ]; then
    echo "Removing backend.tf to prepare for self-bootstrapping in terragrunt configuration."
    rm "${SCRIPT_DIR}/backend.tf"
fi

cd "${SCRIPT_DIR}"
terraform init -input=false
terraform apply --auto-approve
terraform init -input=false -migrate-state -force-copy
terraform plan
cd -
