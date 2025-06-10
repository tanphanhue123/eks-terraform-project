#modules/ses/_outputs.tf
#ses-smtp-user
output "ses_smtp_user_password_v4" {
  value       = aws_iam_access_key.ses_smtp_user_iam_access_key[*].ses_smtp_password_v4
  description = "Secret access key converted into an SES SMTP password"
}
output "ses_smtp_user_name" {
  value       = aws_iam_access_key.ses_smtp_user_iam_access_key[*].id
  description = "Secret access key converted into an SES SMTP username"
}
