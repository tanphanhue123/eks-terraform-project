resource "aws_cloudfront_origin_access_control" "cloudfront_oac" {
  count = contains([for value in var.cloudfront_origins : value.s3_origin_config if value.s3_origin_config != false], true) == true ? 1 : 0

  name                              = "${var.project}-${var.env}-${var.cloudfront_name}-cloudfront-oac"
  description                       = "Origin Access Control - ${var.project}-${var.env}-${var.cloudfront_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
