resource "aws_budgets_budget" "budgets" {
  name              = "${var.project}-${var.env}-${lower(var.time_unit)}-${lower(var.budget_type)}-budgets"
  budget_type       = var.budget_type
  limit_unit        = "USD"
  limit_amount      = var.limit_amount
  time_period_start = var.time_period_start
  time_unit         = var.time_unit

  dynamic "notification" {
    for_each = var.notifications
    content {
      comparison_operator        = "GREATER_THAN"
      threshold                  = notification.value.threshold
      threshold_type             = "PERCENTAGE"
      notification_type          = "ACTUAL"
      subscriber_email_addresses = notification.value.subscriber_email_addresses
      subscriber_sns_topic_arns  = notification.value.subscriber_sns_topic_arns
    }
  }
}
