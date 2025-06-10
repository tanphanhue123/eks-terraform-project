resource "aws_cloudfront_public_key" "cloudfront_public_key" {
  count = var.cloudfront_public_key != null ? 1 : 0

  name        = "${var.project}-${var.env}-${var.cloudfront_name}-cloudfront-public-key"
  comment     = "Public Key - ${var.project}-${var.env}-${var.cloudfront_name}"
  encoded_key = var.cloudfront_public_key
}

resource "aws_cloudfront_key_group" "cloudfront_key_group" {
  count = var.cloudfront_public_key != null ? 1 : 0

  name    = "${var.project}-${var.env}-${var.cloudfront_name}-cloudfront-key-group"
  comment = "Key Group - ${var.project}-${var.env}-${var.cloudfront_name}"
  items   = [aws_cloudfront_public_key.cloudfront_public_key[0].id]
}
