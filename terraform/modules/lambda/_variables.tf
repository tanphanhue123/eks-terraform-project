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
variable "service" {
  description = "AWS service name is associated with Lambda"
  type        = string
}
variable "region" {
  description = "Region of environment"
  type        = string
}

#lambda zip
variable "lambda_zip_python" {
  description = "Use to automatically install packages for Python and compress them into zip file for Lambda Function"
  default     = null
  type = object({
    code_path     = string
    code_zip_path = string
    code_zip_name = string
  })
}

#lambda
variable "lambda_function" {
  description = "All configurations of a Lambda Function resource"
  type = object({
    name                           = string
    role                           = string
    runtime                        = string
    timeout                        = optional(number, 60)
    handler                        = optional(string, null) #Input the handler if don't use the handler from lamba_zip function
    filename                       = optional(string, null) #Input the filename if don't use the filename from lamba_zip function
    memory_size                    = optional(number, 128)
    reserved_concurrent_executions = optional(number, -1)
    package_type                   = optional(string, "Zip")
    layers                         = optional(list(string), [])
    publish                        = optional(bool, false)
    vpc_config = optional(object({
      subnet_ids         = optional(list(string), [])
      security_group_ids = optional(list(string), [])
    }), {})
    dead_letter_config = optional(list(object({
      target_arn = optional(string, null)
    })), [])
    environment_variables = optional(map(any), {})
  })
}

variable "lambda_function_api_gateway" {
  description = "Provide the Name and ARN of the API Gateway you want to trigger to the Lambda Function"
  default     = []
  type = list(object({
    name = string
    arn  = string
  }))
}

variable "lambda_function_sqs" {
  description = "Lambda trigger SQS config"
  default     = []
  type = list(object({
    name                               = string
    arn                                = string
    batch_size                         = number
    maximum_batching_window_in_seconds = optional(number, null)
  }))
}

variable "lambda_function_sns" {
  description = "Provide the Name and ARN of the SNS topics you want to trigger to the Lambda Function"
  default     = []
  type = list(object({
    topic_name = string
    topic_arn  = string
  }))
}

variable "lambda_function_cloudwatch_log" {
  description = "Provide the Name and ARN of the CloudWatch log group you want to trigger to the Lambda Function"
  default     = []
  type = list(object({
    log_subscription_filter_name    = string
    log_group_name                  = string
    log_subscription_filter_pattern = string
  }))
}

variable "lambda_function_s3" {
  description = "Provide the Name and ARN of the S3 you want to trigger to the Lambda Function"
  default     = []
  type = list(object({
    bucket_id  = string
    bucket_arn = string
    bucket_notification = object({
      events        = list(string)
      filter_prefix = string
    })
  }))
}
