output "migrate_state_command" {
    description = "The command to migrate state to the new storage account."
  value = "terraform init -input=false -migrate-state -force-copy"
}
