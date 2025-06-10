#modules/ssm-parameter/_outputs.tf
output "ssm_parameter_name" {
  description = "Name of the SSM parameter"
  value       = aws_ssm_parameter.ssm_parameter.name
}

output "ssm_parameter_value" {
  description = " Value of the SSM parameter"
  value       = aws_ssm_parameter.ssm_parameter.value
}
