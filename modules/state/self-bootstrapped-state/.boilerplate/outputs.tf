output "container_name" {
  value = module.state.container_name
}

output "migrate_state_command" {
  value = module.state.migrate_state_command
}

output "resource_group_name" {
  value = module.state.resource_group_name
}

output "storage_account_name" {
  value = module.state.storage_account_name
}

output "terragrunt_backend_generator" {
  value = module.state.terragrunt_backend_generator
}
