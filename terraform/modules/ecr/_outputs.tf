#modules/ecr/_outputs.tf
output "ecr_name" {
  description = "Name of ECR Repository"
  value       = aws_ecr_repository.ecr.name
}
output "ecr_arn" {
  description = "ARN of ECR Repository"
  value       = aws_ecr_repository.ecr.arn
}
output "ecr_repo_url" {
  description = "URL of ECR Repository"
  value       = aws_ecr_repository.ecr.repository_url
}
