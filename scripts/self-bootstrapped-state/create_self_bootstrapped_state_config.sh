#!/bin/bash

# This script creates a self-bootstrapped state terraform config.
# It accepts a base name as the first argument, it must contain only lowercase letters and hyphens.
# Any hyphens must not be at the beginning or end of the name.

# The second argument is the path where the terraform config will be deployed.

# Verify the number of arguments is not less than 2
if [ "$#" -gt 1 ]; then
    # Ensure the first argument contains only lowercase characters and hyphens; hyphens may not be the first or last character
    if ! [[ "$1" =~ ^[a-z-]+$ ]]; then
        echo "Invalid game prefix: $1"
        exit 1
    fi
    if [ "${1:0:1}" == "-" ] || [ "${1:${#1}-1}" == "-" ]; then
        echo "Invalid game prefix: $1"
        exit 1
    fi
else
    echo "Please provide a base name as the first argument."
    exit 1
fi

# Ensure the second argument is a valid folder path and then export to TF_CONFIG_PATH
if [ -d "$2" ]; then
    export TF_CONFIG_PATH="$2"
else
    echo "Please provide a valid folder path as the second argument. (TF Config Path)"
    exit 1
fi

# If there is a third agrument verify that it is a valid folder path
if [ "$#" -gt 2 ]; then
    if [ -d "$3" ]; then
        export MAYBE_TG_GERNERATOR_PATH="terragrunt_backend_generator_folder = \"$3\""
        export MAYBE_TG_GENERATE="bootstrap_styles = [\"terragrunt\", \"terraform\"]"
    else
        echo "Please provide a valid folder path as the third argument. (TG Generator Path)"
        exit 1
    fi
else
    export MAYBE_TG_GERNERATOR_PATH=""
    export MAYBE_TG_GENERATE=""
fi

export SBS_RG_NAME="$1-rg"
export SBS_SA_NAME="$(echo ${1}sa | sed 's/-//g')"
export SBS_SC_NAME="$(echo ${1}sc | sed 's/-//g')"

cat << EOF > "${TF_CONFIG_PATH}/main.tf"
provider "azurerm" {
  features {}
}

variable "enable_remote" {
  description = "The current configuration for the module to use. By first setting this to false and applying we can safely destroy."
  type        = bool
  default     = true
}

module "state" {
  # TODO - we need a real ref here
  source = "git@github.com:je-sidestuff/terraform-azure-simple-modules.git//modules/state/self-bootstrapped-state/?ref=feat/environment_deployment_support"

  enable_remote = var.enable_remote

  resource_group_name  = "$SBS_RG_NAME"
  storage_account_name = "$SBS_SA_NAME"
  root_container_name  = "$SBS_SC_NAME"

  $MAYBE_TG_GENERATE

  $MAYBE_TG_GERNERATOR_PATH

  # tags = var.tags TODO - we probably want tags
}
EOF

cat << EOF > "${TF_CONFIG_PATH}/self_bootstrap.sh"
#!/bin/bash

# This script executes the multi-phase process of self-bootstrapping.
# It first applies the module with the assumption thati t has not yet been applied, and then runs the migration command.
# It then plans again to verify no changes.

terraform init -input=false
terraform apply --auto-approve
terraform init -input=false -migrate-state -force-copy
terraform plan
EOF

cat << EOF > "${TF_CONFIG_PATH}/destroy_state.sh"
#!/bin/bash

# This script executes the multi-phase process of destroying self-bootstrapped state.
# It first applies the module with local state, and then runs the migration command.
# It then destroys the module once the state has been brought local.

export TF_VAR_enable_remote=false
terraform apply --auto-approve
terraform init -input=false -migrate-state -force-copy
terraform destroy --auto-approve
EOF

chmod +x "${TF_CONFIG_PATH}/self_bootstrap.sh"
chmod +x "${TF_CONFIG_PATH}/destroy_state.sh"
