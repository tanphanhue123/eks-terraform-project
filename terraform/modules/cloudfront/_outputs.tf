#modules/cloudfront/_output.tf
output "cloudfront_arn" {
  description = "ARN for the distribution."
  value       = aws_cloudfront_distribution.cloudfront.arn
}
output "cloudfront_cache_policy_id" {
  description = "The identifier for the cache policy."
  value       = length(var.cloudfront_cache_policies) > 0 ? { for key, value in aws_cloudfront_cache_policy.cloudfront_cache_policy : key => value.id } : {}
}
output "cloudfront_default_cache_policy_id" {
  description = "The identifier for the default cache policy."
  value       = length(var.cloudfront_default_cache_policies) > 0 ? { for key, value in data.aws_cloudfront_cache_policy.cloudfront_default_cache_policy : key => value.id } : {}
}
output "cloudfront_default_origin_request_policy_id" {
  description = "Identifier of the default origin request policy"
  value       = length(var.cloudfront_default_origin_request_policies) > 0 ? { for key, value in data.aws_cloudfront_origin_request_policy.cloudfront_default_origin_request_policy : key => value.id } : {}
}
output "cloudfront_domain_name" {
  description = "DNS domain name of either the S3 bucket, or web site of your custom origin"
  value       = aws_cloudfront_distribution.cloudfront.domain_name
}
output "cloudfront_hosted_zone_id" {
  description = "CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to"
  value       = aws_cloudfront_distribution.cloudfront.hosted_zone_id
}
output "cloudfront_id" {
  description = "Identifier for the distribution"
  value       = aws_cloudfront_distribution.cloudfront.id
}
output "origin_access_control_id" {
  description = "Identifier for origin access control"
  value       = contains([for value in var.cloudfront_origins : value.s3_origin_config if value.s3_origin_config != false], true) == true ? aws_cloudfront_origin_access_control.cloudfront_oac[0].id : null
}
output "cloudfront_key_group_id" {
  description = "The identifier for the cache policy."
  value       = var.cloudfront_public_key != null ? aws_cloudfront_public_key.cloudfront_public_key[0].id : null
}
