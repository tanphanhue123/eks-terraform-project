resource "aws_lambda_permission" "lambda_permission_cloudwatch_log" {
  count = var.lambda_function_arn != null ? 1 : 0

  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "logs.${var.region}.amazonaws.com"
}

resource "aws_cloudwatch_log_subscription_filter" "log_subscription_filter" {
  for_each = { for value in var.cloudwatch_log_filter : value.log_subscription_filter_name => value }

  name            = "${var.project}-${var.env}-${each.value.log_subscription_filter_name}-filter"
  log_group_name  = each.value.log_group_name
  filter_pattern  = each.value.log_subscription_filter_pattern
  destination_arn = each.value.lambda_function_arn
}
