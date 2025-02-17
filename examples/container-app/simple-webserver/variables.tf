# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

# Nope!

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "location" {
  description = "The location where the container runtime will be deployed."
  type        = string
  default     = "eastus"
}

variable "hosted_message" {
  type        = string
  description = "The message to display on the web server."
  default     = <<EOF
<!DOCTYPE html>
<html>
    <body>
        <h1>"Hello world..!"</h1>
    </body>
</html>
EOF
}

variable "naming_prefix" {
  type        = string
  description = "A prefix to use for naming the Container Apps Environment."
  default     = "generate"
}

variable "tags" {
  description = "Tags to be added to the container app environment."
  type        = map(string)
  default     = {}
}
