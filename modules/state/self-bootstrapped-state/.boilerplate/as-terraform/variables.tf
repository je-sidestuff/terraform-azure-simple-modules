variable "enable_remote" {
  description = "The current configuration for the module to use. By first setting this to false and applying we can safely destroy."
  type        = bool
  default     = true
}
