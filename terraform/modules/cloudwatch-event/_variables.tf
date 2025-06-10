#modules/cloudwatch-event/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#cloudwatch-event
variable "cloudwatch_event_rule" {
  description = "All configurations about Cloudwatch Event Rule"
  type = object(
    {
      name                = string
      description         = string
      event_pattern       = optional(string, null)
      schedule_expression = optional(string, null)
    }
  )
}
variable "cloudwatch_event_targets" {
  description = "All configurations about Cloudwatch Event Targets"
  type = map(object(
    {
      arn      = string
      role_arn = optional(string, null)
    }
  ))
}
