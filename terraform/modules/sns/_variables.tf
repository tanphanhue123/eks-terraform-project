#modules/sns/_variables.tf
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

#sns
variable "service" {
  description = "AWS service name is associated with SNS"
  type        = string
  validation {
    condition     = contains(["inspector", "codepipeline", "budgets", "cloudwatch", "ses", "sqs", "kinesis", "lambda"], var.service)
    error_message = "Invalid input, valid values: [\"inspector\", \"codepipeline\", \"budgets\", \"cloudwatch\", \"ses\", \"ses\", \"sqs\", \"lambda\"]."
  }
}
variable "sns_topic_name" {
  description = "Name of SNS topic"
  type        = string
}
variable "sns_topic_subscription_email_address" {
  description = "List of email addresses to subscribe to SNS topic"
  type        = list(string)
  default     = []
}
