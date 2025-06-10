# Email Receiving - MX Record
resource "aws_route53_record" "ses_verification_mx_record_receiving" {
  count = var.ses_email_receiving != null ? 1 : 0

  zone_id = var.route53_zone_id
  name    = aws_ses_domain_identity.ses_domain_identity.id
  type    = "MX"
  ttl     = "600"
  records = ["10 inbound-smtp.${var.region}.amazonaws.com"]
}

resource "aws_ses_receipt_rule_set" "ses_receipt_rule_set" {
  count = var.ses_email_receiving != null ? 1 : 0

  rule_set_name = var.ses_email_receiving.receipt_rule_set_name
}

resource "aws_ses_active_receipt_rule_set" "ses_active_receipt_rule_set" {
  count = var.ses_email_receiving != null ? 1 : 0

  rule_set_name = aws_ses_receipt_rule_set.ses_receipt_rule_set[0].rule_set_name
}

resource "aws_ses_receipt_rule" "ses_receipt_rule" {
  count = var.ses_email_receiving != null ? 1 : 0

  name          = var.ses_email_receiving.receipt_rule.name
  rule_set_name = aws_ses_receipt_rule_set.ses_receipt_rule_set[0].rule_set_name
  recipients    = var.ses_email_receiving.receipt_rule.recipients
  enabled       = true
  scan_enabled  = true

  dynamic "s3_action" {
    for_each = length(var.ses_email_receiving.receipt_rule.s3_actions) > 0 ? var.ses_email_receiving.receipt_rule.s3_actions : []
    content {
      position          = s3_action.value.position
      bucket_name       = s3_action.value.bucket_name
      object_key_prefix = s3_action.value.object_key_prefix
      kms_key_arn       = s3_action.value.kms_key_arn
      topic_arn         = s3_action.value.topic_arn
    }
  }

  dynamic "sns_action" {
    for_each = length(var.ses_email_receiving.receipt_rule.sns_actions) > 0 ? var.ses_email_receiving.receipt_rule.sns_actions : []
    content {
      position  = sns_action.value.position
      topic_arn = sns_action.value.topic_arn
      encoding  = sns_action.value.encoding
    }
  }

  dynamic "lambda_action" {
    for_each = length(var.ses_email_receiving.receipt_rule.lambda_actions) > 0 ? var.ses_email_receiving.receipt_rule.lambda_actions : []
    content {
      position        = lambda_action.value.position
      function_arn    = lambda_action.value.function_arn
      invocation_type = lambda_action.value.invocation_type
      topic_arn       = lambda_action.value.topic_arn
    }
  }
}
