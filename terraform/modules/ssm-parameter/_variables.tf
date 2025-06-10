#modules/ssm-parameter/_variables.tf
#ssm-parameter
variable "name" {
  description = "Name of the SSM parameter"
  type        = string
}
variable "value" {
  description = "Value of the SSM parameter"
  type        = string
}
variable "key_id" {
  description = "KMS key ID or ARN for encrypting a SecureString"
  type        = string
  default     = null
}
variable "type" {
  description = "Type of the parameter"
  default     = "SecureString"
  type        = string
  validation {
    condition     = contains(["String", "StringList", "SecureString"], var.type)
    error_message = "Invalid input, valid values: [\"String\", \"StringList\", \"SecureString\"]."
  }
}
