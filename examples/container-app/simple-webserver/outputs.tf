output "aca_endpoint" {
  value       = "https://${module.webapp_aca.name}.${module.container_app_environment.default_domain}"
  description = "The fully qualified domain name of the most recent container app revision."
}
