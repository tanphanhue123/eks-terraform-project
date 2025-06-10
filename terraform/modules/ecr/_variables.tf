#modules/ecr/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#ecr
variable "ecr_name" {
  description = "Name of ECR repository"
  type        = string
}
variable "ecr_lifecycle_policy" {
  description = "Lifecycle policy for ECR repository"
  type        = string
}
variable "scan_on_push" {
  description = "Scan on push for image"
  type        = bool
  default     = false
}
