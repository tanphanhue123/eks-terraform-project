resource "aws_cloudtrail" "cloudtrail" {
  name                          = "${var.project}-${var.env}-cloudtrail"
  s3_bucket_name                = var.cloudtrail.s3_bucket_name
  s3_key_prefix                 = var.cloudtrail.s3_key_prefix
  include_global_service_events = true
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  kms_key_id                    = var.cloudtrail.kms_key_arn

  tags = {
    Name = "${var.project}-${var.env}-cloudtrail"
  }
}
