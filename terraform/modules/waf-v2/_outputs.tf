#modules/wafv2-app/outputs.tf
output "wafv2_web_acl_arn" {
  value = aws_wafv2_web_acl.wafv2_web_acl.arn
}

output "wafv2_web_acl_name" {
  value = aws_wafv2_web_acl.wafv2_web_acl.name
}
