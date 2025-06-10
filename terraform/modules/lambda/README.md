# lambda

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.56.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_subscription_filter.log_subscription_filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_lambda_event_source_mapping.lambda_event_source_mapping_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_lambda_function.lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function_event_invoke_config.lambda_function_event_invoke_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_event_invoke_config) | resource |
| [aws_lambda_permission.lambda_permission_api_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.lambda_permission_cloudwatch_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.lambda_permission_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.lambda_permission_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket_notification.s3_bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_sns_topic_subscription.sns_topic_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [null_resource.install_python_dependencies](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | Name of project environment | `string` | n/a | yes |
| <a name="input_lambda_function"></a> [lambda\_function](#input\_lambda\_function) | All configurations of a Lambda Function resource | <pre>object({<br>    name                           = string<br>    role                           = string<br>    runtime                        = string<br>    timeout                        = optional(number, 60)<br>    handler                        = optional(string, null) #Input the handler if don't use the handler from lamba_zip function<br>    filename                       = optional(string, null) #Input the filename if don't use the filename from lamba_zip function<br>    memory_size                    = optional(number, 128)<br>    reserved_concurrent_executions = optional(number, -1)<br>    package_type                   = optional(string, "Zip")<br>    layers                         = optional(list(string), [])<br>    publish                        = optional(bool, false)<br>    vpc_config = optional(object({<br>      subnet_ids         = optional(list(string), [])<br>      security_group_ids = optional(list(string), [])<br>    }), {})<br>    dead_letter_config = optional(list(object({<br>      target_arn = optional(string, null)<br>    })), [])<br>    environment_variables = optional(map(any), {})<br>  })</pre> | n/a | yes |
| <a name="input_lambda_function_api_gateway"></a> [lambda\_function\_api\_gateway](#input\_lambda\_function\_api\_gateway) | Provide the Name and ARN of the API Gateway you want to trigger to the Lambda Function | <pre>list(object({<br>    name = string<br>    arn  = string<br>  }))</pre> | `[]` | no |
| <a name="input_lambda_function_cloudwatch_log"></a> [lambda\_function\_cloudwatch\_log](#input\_lambda\_function\_cloudwatch\_log) | Provide the Name and ARN of the CloudWatch log group you want to trigger to the Lambda Function | <pre>list(object({<br>    log_subscription_filter_name    = string<br>    log_group_name                  = string<br>    log_subscription_filter_pattern = string<br>  }))</pre> | `[]` | no |
| <a name="input_lambda_function_s3"></a> [lambda\_function\_s3](#input\_lambda\_function\_s3) | Provide the Name and ARN of the S3 you want to trigger to the Lambda Function | <pre>list(object({<br>    bucket_id  = string<br>    bucket_arn = string<br>    bucket_notification = object({<br>      events        = list(string)<br>      filter_prefix = string<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_lambda_function_sns"></a> [lambda\_function\_sns](#input\_lambda\_function\_sns) | Provide the Name and ARN of the SNS topics you want to trigger to the Lambda Function | <pre>list(object({<br>    topic_name = string<br>    topic_arn  = string<br>  }))</pre> | `[]` | no |
| <a name="input_lambda_function_sqs"></a> [lambda\_function\_sqs](#input\_lambda\_function\_sqs) | Lambda trigger SQS config | <pre>list(object({<br>    name                               = string<br>    arn                                = string<br>    batch_size                         = number<br>    maximum_batching_window_in_seconds = optional(number, null)<br>  }))</pre> | `[]` | no |
| <a name="input_lambda_zip_python"></a> [lambda\_zip\_python](#input\_lambda\_zip\_python) | Use to automatically install packages for Python and compress them into zip file for Lambda Function | <pre>object({<br>    code_path     = string<br>    code_zip_path = string<br>    code_zip_name = string<br>  })</pre> | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region of environment | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | AWS service name is associated with Lambda | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | Amazon Resource Name (ARN) identifying your Lambda Function |
| <a name="output_lambda_function_invoke_arn"></a> [lambda\_function\_invoke\_arn](#output\_lambda\_function\_invoke\_arn) | ARN to be used for invoking Lambda Function from API Gateway |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | Name of Lambda Function |
| <a name="output_lambda_function_qualified_arn"></a> [lambda\_function\_qualified\_arn](#output\_lambda\_function\_qualified\_arn) | Amazon Resource Name (ARN) identifying your Lambda Function Version |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
