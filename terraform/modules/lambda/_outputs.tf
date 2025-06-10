#modules/lambda/_outputs.tf
#lambda
output "lambda_function_name" {
  description = "Name of Lambda Function"
  value       = aws_lambda_function.lambda_function.function_name
}
output "lambda_function_arn" {
  description = "Amazon Resource Name (ARN) identifying your Lambda Function"
  value       = aws_lambda_function.lambda_function.arn
}
output "lambda_function_invoke_arn" {
  description = "ARN to be used for invoking Lambda Function from API Gateway"
  value       = aws_lambda_function.lambda_function.invoke_arn
}
output "lambda_function_qualified_arn" {
  description = "Amazon Resource Name (ARN) identifying your Lambda Function Version"
  value       = aws_lambda_function.lambda_function.qualified_arn
}
