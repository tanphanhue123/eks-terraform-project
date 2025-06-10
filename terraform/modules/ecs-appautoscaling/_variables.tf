#modules/ecs-appautoscaling/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#ecs-appautoscaling
variable "ecs_appautoscaling_target" {
  description = "Targets configurations to Provides a ECS Auto Scaling resource"
  default     = null
  type = object({
    service_name = string
    cluster_name = string
    min_capacity = number
    max_capacity = number
  })
}

variable "ecs_appautoscaling_policies" {
  description = "Policies configurations to Provides a ECS Auto Scaling resource"
  default     = []
  type = list(object({
    name     = string
    cooldown = number
    step_adjustments = list(object({
      metric_interval_lower_bound = number
      metric_interval_upper_bound = number
      scaling_adjustment          = number
    }))
  }))
}
