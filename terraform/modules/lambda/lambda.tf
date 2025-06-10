resource "aws_lambda_function" "lambda_function" {
  function_name                  = "${var.project}-${var.env}-${var.lambda_function.name}-lambda"
  description                    = "from ${var.service}: to Lambda"
  role                           = var.lambda_function.role
  timeout                        = var.lambda_function.timeout
  memory_size                    = var.lambda_function.memory_size
  reserved_concurrent_executions = var.lambda_function.reserved_concurrent_executions
  layers                         = var.lambda_function.layers

  #file
  runtime          = var.lambda_function.runtime
  handler          = local.lambda_handler
  filename         = local.lambda_filename
  source_code_hash = filebase64sha256(local.lambda_filename)
  package_type     = var.lambda_function.package_type

  # Publish version to attach to cloudfront
  publish = var.lambda_function.publish

  # Lambda in VPC
  dynamic "vpc_config" {
    for_each = var.lambda_function.vpc_config != {} ? [var.lambda_function.vpc_config] : []
    content {
      subnet_ids         = var.lambda_function.vpc_config.subnet_ids
      security_group_ids = var.lambda_function.vpc_config.security_group_ids
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.lambda_function.dead_letter_config
    content {
      target_arn = var.lambda_function.dead_letter_config.target_arn
    }
  }

  dynamic "environment" {
    for_each = length(var.lambda_function.environment_variables) > 0 ? [var.lambda_function.environment_variables] : []
    content {
      variables = var.lambda_function.environment_variables
    }
  }

  tracing_config {
    mode = "PassThrough"
  }

  tags = {
    Name    = "${var.project}-${var.env}-${var.lambda_function.name}-lambda"
    Service = var.service
  }
}

resource "aws_lambda_function_event_invoke_config" "lambda_function_event_invoke_config" {
  function_name                = aws_lambda_function.lambda_function.function_name
  qualifier                    = "$LATEST"
  maximum_event_age_in_seconds = 21600
  maximum_retry_attempts       = 0
}

#==================================================================================
# For API Gateway
resource "aws_lambda_permission" "lambda_permission_api_gateway" {
  for_each = { for value in var.lambda_function_api_gateway : value.name => value }

  statement_id  = "AllowExecutionFromAPIGateway-${each.value.name}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${each.value.arn}/*/*/*"
}

#==================================================================================
# For SQS
resource "aws_lambda_event_source_mapping" "lambda_event_source_mapping_sqs" {
  for_each = { for value in var.lambda_function_sqs : value.name => value }

  enabled                            = true
  function_name                      = aws_lambda_function.lambda_function.arn
  event_source_arn                   = each.value.arn
  batch_size                         = each.value.batch_size
  maximum_batching_window_in_seconds = each.value.maximum_batching_window_in_seconds
}

#==================================================================================
# For SNS
resource "aws_lambda_permission" "lambda_permission_sns" {
  for_each = { for value in var.lambda_function_sns : value.topic_name => value }

  statement_id  = "AllowExecutionFromSNS-${each.value.topic_name}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = each.value.topic_arn
}

resource "aws_sns_topic_subscription" "sns_topic_subscription" {
  for_each = { for value in var.lambda_function_sns : value.topic_name => value }

  topic_arn = each.value.topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda_function.arn
}

#==================================================================================
# For Cloudwatch Log
resource "aws_lambda_permission" "lambda_permission_cloudwatch_log" {
  count = length(var.lambda_function_cloudwatch_log) > 0 ? 1 : 0

  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.arn
  principal     = "logs.${var.region}.amazonaws.com"
}

resource "aws_cloudwatch_log_subscription_filter" "log_subscription_filter" {
  for_each = { for value in var.lambda_function_cloudwatch_log : value.log_subscription_filter_name => value }

  name            = "${var.project}-${var.env}-${each.value.log_subscription_filter_name}-filter"
  log_group_name  = each.value.log_group_name
  filter_pattern  = each.value.log_subscription_filter_pattern
  destination_arn = aws_lambda_function.lambda_function.arn
}

#==================================================================================
# For S3
resource "aws_lambda_permission" "lambda_permission_s3" {
  for_each = { for value in var.lambda_function_s3 : value.bucket_id => value }

  statement_id  = "AllowExecutionFromS3Bucket-${each.value.bucket_id}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.arn
  principal     = "s3.amazonaws.com"
  source_arn    = each.value.bucket_arn
}

resource "aws_s3_bucket_notification" "s3_bucket_notification" {
  for_each = { for value in var.lambda_function_s3 : value.bucket_id => value }

  bucket = each.value.bucket_id
  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_function.arn
    events              = each.value.bucket_notification.events
    filter_prefix       = each.value.bucket_notification.filter_prefix
  }
}
