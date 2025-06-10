#modules/cloudwatch-alarm/variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#cloudwatch-alarm
variable "service" {
  description = "AWS service name"
  type        = string
}
variable "type" {
  description = "Application name"
  type        = string
}
variable "cloudwatch_alarms" {
  description = "All configurations about Cloudwatch Alarms"
  type = list(object(
    {
      name                = string
      metric_name         = string
      namespace           = string
      comparison_operator = string
      statistic           = string
      threshold           = string
      unit                = string
      datapoints_to_alarm = string
      evaluation_periods  = string
      period              = string
      dimensions          = map(any)
      alarm_actions       = list(string)
      ok_actions          = optional(list(string), [])
    }
  ))
}
