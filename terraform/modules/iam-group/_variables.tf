#modules/iam-group/_variables.tf
variable "iam_group_name" {
  description = "Name of IAM Group"
  type        = string
}

variable "aws_managed_policy_arn" {
  description = "ARN IAM Ppolicy for AWS managed"
  type        = list(string)
  default     = []
}
variable "user_attachments" {
  description = "IAM User attach to group"
  type        = list(string)
  default     = []
}
variable "iam_custom_policy" {
  description = "Policy of customer managed"
  type        = string
  default     = null
}
