#!/bin/bash

# This script executes the multi-phase process of destroying self-bootstrapped state.
# It first applies the module with local state, and then runs the migration command.
# It then destroys the module once the state has been brought local.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd "${SCRIPT_DIR}/.."
export TF_VAR_enable_remote=false
terraform apply --auto-approve
terraform init -input=false -migrate-state -force-copy
terraform destroy --auto-approve
cd -