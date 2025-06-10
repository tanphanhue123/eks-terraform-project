#modules/ecs-appautoscaling/_outputs.tf
output "ecs_appautoscaling_policy_arn" {
  description = "ARN assigned by AWS to the scaling policy"
  value       = { for key, value in aws_appautoscaling_policy.ecs_appautoscaling_policy : key => value.arn }
}
