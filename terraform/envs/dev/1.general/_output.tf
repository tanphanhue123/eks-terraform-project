output "aws_account_id" {
  value       = <<VALUE

  Check AWS Env:
    Project : "${var.project}" | Env: "${var.env}"
    AWS Account ID: "${data.aws_caller_identity.current.account_id}"
    AWS Account ARN: "${data.aws_caller_identity.current.arn}"
  VALUE
  description = "Show information about project, environment and account"
}
# Output modules
#VPC
output "vpc_id" {
  value       = module.vpc-eks.vpc_id
  description = "ID of VPC"
}
output "subnet_private_id" {
  value       = module.vpc-eks.subnet_private_id
  description = "ID of Private Subnet"
}
output "subnet_public_id" {
  value       = module.vpc-eks.subnet_public_id
  description = "ID of Public Subnet"
}
