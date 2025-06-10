resource "aws_cloudwatch_event_rule" "cloudwatch_event_rule" {
  name                = "${var.project}-${var.env}-${var.cloudwatch_event_rule.name}-event"
  description         = var.cloudwatch_event_rule.description
  event_pattern       = var.cloudwatch_event_rule.event_pattern
  schedule_expression = var.cloudwatch_event_rule.schedule_expression
}

resource "aws_cloudwatch_event_target" "cloudwatch_event_target" {
  for_each = var.cloudwatch_event_targets

  rule      = aws_cloudwatch_event_rule.cloudwatch_event_rule.name
  target_id = "${aws_cloudwatch_event_rule.cloudwatch_event_rule.name}-${each.key}"
  arn       = each.value.arn
  role_arn  = each.value.role_arn
}
