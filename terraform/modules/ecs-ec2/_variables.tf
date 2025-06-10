variable "project" {
    description = "The name of project"
    type = string
    default = null
}
variable "env" {
    description = "The env of project"
    type = string
    default = null
}
variable "ecs_services" {
    description = "ecs services"
    type = list(object({
      name   = string
      alarms = optional(list(object({
        name     = string
        enable   = string
        rollback = string
      })))
      cluster = optional(string, null)
      deployment_controller = object({
        type = optional(string,"ECS")})
      deployment_maximum_percent = optional(number,null)
      deployment_minimum_healthy_percent =optional(number,null)
      desired_count = optional(number,null)
      enable_execute_command = optional(bool,true)
      iam_role      = optional(string,null)
      launch_type   = optional(string,"EC2")
      load_balancer = optional(object({
        target_group_arn = string
        container_name   = string
        container_port   = string
      }),null)
      network_configuration = object({
        subnet           = list(string)
        security_group   = list(string)
        assign_public_ip = optional(bool,false)
      })
    }))  
}