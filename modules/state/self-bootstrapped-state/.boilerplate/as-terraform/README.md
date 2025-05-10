# Self-bootstrapped state as terraform

This subdirectory is an interface to the self-bootstrapped state objects through a terraform interface.

The purpose of this directory is to allow the caller to manage the state using the standup and teardown scripts, even if they are using terragrunt as their primary interface. This is done so we can avoid duplicating the scripts to target terragrunt. For now we are accepting the trade-off of duplicating and coordinating the configs so that the terraform can be used as the management interface for the self-bootstrapped state and the terragrunt can be used to read outputs.