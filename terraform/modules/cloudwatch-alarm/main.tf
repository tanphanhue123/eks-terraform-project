resource "aws_cloudwatch_metric_alarm" "cloudwatch_alarm" {
  for_each = { for value in var.cloudwatch_alarms : "${var.service}-${var.type}-${value.name}" => value }

  alarm_name          = "${var.project}-${var.env}-${var.service}-${var.type}-${each.value.name}"
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  comparison_operator = each.value.comparison_operator
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  datapoints_to_alarm = each.value.datapoints_to_alarm
  evaluation_periods  = each.value.evaluation_periods # Evaluation Period must to larger than Datapoints
  period              = each.value.period
  treat_missing_data  = "notBreaching"
  alarm_description   = "${each.value.statistic} of ${var.service} ${var.type} ${each.value.metric_name} ${each.value.comparison_operator} is ${each.value.threshold}${each.value.unit}: Reach ${each.value.datapoints_to_alarm} times in ${each.value.evaluation_periods}x${each.value.period} seconds"
  dimensions          = each.value.dimensions
  alarm_actions       = each.value.alarm_actions
  ok_actions          = each.value.ok_actions
}
