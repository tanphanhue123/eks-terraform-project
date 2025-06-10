#modules/sns/_outputs.tf
output "sns_topic_arn" {
  description = "ARN of AWS SNS topic"
  value       = aws_sns_topic.sns_topic.arn
}
output "sns_topic_name" {
  description = "Name of AWS SNS topic"
  value       = aws_sns_topic.sns_topic.name
}
