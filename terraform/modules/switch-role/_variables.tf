#modules/switch-role/_variables.tf
#switch-role
variable "switch_role_name" {
  description = "Name of IAM Role/IAM Policy/IAM Instance Profile"
  type        = string
}
variable "assume_role_policy" {
  description = "Assume role policy of IAM Role"
  type        = string
}
variable "aws_managed_policy_arn" {
  description = "ARN of IAM Default Policies managed by AWS"
  type        = list(string)
  default     = []
}
variable "iam_custom_policy" {
  description = "Custom Policy of IAM Role"
  default     = null
  type = object({
    template = optional(string, null)
  })
}
