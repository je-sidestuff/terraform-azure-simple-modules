output "image_name" {
  description = "The full name of the image."
  value       = "${var.acr_name}.azurecr.io/${var.image_name}:${var.image_tag}"
}
