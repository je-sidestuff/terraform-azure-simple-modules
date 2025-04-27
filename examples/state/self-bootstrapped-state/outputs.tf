output "migrate_state_command" {
    description = "The command to migrate state to the new storage account."
  value = module.state.migrate_state_command
}
