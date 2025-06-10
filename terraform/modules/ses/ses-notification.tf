# SES Identity Notification
resource "aws_ses_identity_notification_topic" "ses_identity_notification" {
  count = var.ses_identity_notification != null ? length(var.ses_identity_notification.type) : 0

  topic_arn                = var.ses_identity_notification.topic_arn
  notification_type        = element(var.ses_identity_notification.type, count.index)
  identity                 = aws_ses_domain_identity.ses_domain_identity.domain
  include_original_headers = true
}
