#modules/iam/_variables.tf
variable "iam_users" {
  description = "IAM User"
  type        = list(string)
}
