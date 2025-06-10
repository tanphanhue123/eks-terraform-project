#modules/lambda/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

variable "region" {
  description = "Region of environment"
  type        = string
}

variable "cloudwatch_log_filter" {
  description = "Provide the Name and ARN of the CloudWatch log group you want to trigger to the Lambda Function"
  default     = []
  type = list(object({
    log_subscription_filter_name    = string
    log_group_name                  = string
    log_subscription_filter_pattern = string
    lambda_function_arn             = string
  }))
}

variable "lambda_function_arn" {
  description = "Arn of Lambda funtion"
  default     = null
  type        = string
}
