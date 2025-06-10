###################
# ECS Auto Scaling
###################
resource "aws_appautoscaling_target" "ecs_appautoscaling_target" {
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"
  resource_id        = "service/${var.ecs_appautoscaling_target.cluster_name}/${var.ecs_appautoscaling_target.service_name}"
  min_capacity       = var.ecs_appautoscaling_target.min_capacity
  max_capacity       = var.ecs_appautoscaling_target.max_capacity
}

resource "aws_appautoscaling_policy" "ecs_appautoscaling_policy" {
  for_each = { for value in var.ecs_appautoscaling_policies : value.name => value }

  name               = "${var.project}-${var.env}-${each.value.name}-appautoscaling-policy:${aws_appautoscaling_target.ecs_appautoscaling_target.resource_id}"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_appautoscaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_appautoscaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_appautoscaling_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Average"
    cooldown                = each.value.cooldown
    dynamic "step_adjustment" {
      for_each = each.value.step_adjustments
      content {
        metric_interval_lower_bound = step_adjustment.value.metric_interval_lower_bound
        metric_interval_upper_bound = step_adjustment.value.metric_interval_upper_bound
        scaling_adjustment          = step_adjustment.value.scaling_adjustment
      }
    }
  }
}
