#modules/budgets/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#budgets
variable "time_unit" {
  type        = string
  default     = "MONTHLY"
  description = " (Required) The length of time until a budget resets the actual and forecasted spend. Valid values: MONTHLY, QUARTERLY, ANNUALLY, and DAILY."
}

variable "budget_type" {
  type        = string
  default     = "COST"
  description = "(Required) Whether this budget tracks monetary cost or usage."
}

variable "limit_amount" {
  type        = string
  description = "(Required) The amount of cost or usage being measured for a budget."
}

variable "time_period_start" {
  type        = string
  description = " (Optional) The start of the time period covered by the budget. If you don't specify a start date, AWS defaults to the start of your chosen time period. The start date must come before the end date. Format: 2017-01-01_12:00."
}

variable "notifications" {
  description = "(Optional) Object containing Budget Notifications. Can be used multiple times to define more than one budget notification."
  type = list(object({
    threshold                  = number
    subscriber_email_addresses = optional(list(string), [])
    subscriber_sns_topic_arns  = optional(list(string), [])
  }))
}
