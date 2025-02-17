resource "terraform_data" "build_image_in_acr" {
  provisioner "local-exec" {
    command = <<-EOT
    az account set --subscription ${var.subscription_id}
    az acr build --registry ${var.acr_name} --image ${var.image_name}:${var.image_tag} ${var.docker_context}
  EOT
  }
}