#modules/switch-role/_outputs.tf
#switch-role
output "iam_role_arn" {
  value       = aws_iam_role.iam_role.arn
  description = "ARN of IAM Role"
}
