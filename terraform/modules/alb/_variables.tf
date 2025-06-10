#modules/alb-bg/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#alb
variable "type" {
  description = "Name of application type"
  type        = string
}

variable "alb" {
  description = "All configurations to Provides a Load Balancer resource"
  type = object({
    internal           = optional(bool, false)
    security_group_ids = list(string)
    subnet_ids         = list(string)
    logs_bucket_id     = optional(string)
  })
}

variable "alb_target_group" {
  description = "All configurations to Provides a Target Group resources of Load Balancer resource"
  default     = {}
  type = object({
    vpc_id = optional(string, null)
    target_groups = optional(list(object({
      name                 = string
      target_type          = string
      port                 = number
      deregistration_delay = optional(string, 300)
      health_check = object({
        port                = number
        path                = string
        healthy_threshold   = optional(number, 3)
        unhealthy_threshold = optional(number, 3)
        interval            = optional(number, 30)
        timeout             = optional(number, null)
        matcher             = optional(number, 200)
      })
    })), [])
  })
}

variable "alb_listeners" {
  description = "All configurations to Provides a Load Balancer Listener resources"
  default     = []
  type = list(object({
    port            = number
    protocol        = string
    ssl_policy      = optional(string, null)
    certificate_arn = optional(string, null)
    default_action = object({
      type = string
      redirect = optional(object({
        port = number
      }), null)
      forward = optional(object({
        target_group_arn = string
      }), null)
      fixed_response = optional(object({
        content_type = optional(string, null)
        status_code  = optional(number, null)
        message_body = optional(object({
          template = optional(string, null)
          vars     = optional(map(any), {})
        }), {})
      }), {})
    })
  }))
}

variable "alb_listener_rules" {
  description = "All configurations to Provides a Load Balancer Listener Rule resources"
  default     = []
  type = list(object({
    listener_arn = string
    priority     = number
    condition = object({
      type   = string
      values = list(string)
    })
    action = object({
      type = string
      forward = optional(object({
        target_group_arn = optional(string, null)
      }), {})
      fixed_response = optional(object({
        content_type = optional(string, null)
        status_code  = optional(number, null)
        message_body = optional(object({
          template = optional(string, null)
          vars     = optional(map(any), {})
        }), {})
      }), {})
    })
  }))
}
