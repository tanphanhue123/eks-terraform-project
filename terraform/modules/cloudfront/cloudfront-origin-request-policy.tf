resource "aws_cloudfront_origin_request_policy" "cloudfront_origin_request_policy" {
  for_each = { for value in var.cloudfront_origin_request_policies : value.name => value }
  name     = "${var.project}-${var.env}-${each.value.name}-origin-request-policy"
  comment  = "Origin request Policy - ${var.project}-${var.env}-${each.value.name}"
  cookies_config {
    cookie_behavior = each.value.cookies_config.cookie_behavior
    dynamic "cookies" {
      for_each = (each.value.cookies_config.cookie_behavior == "whitelist" || each.value.cookies_config.cookie_behavior == "allExcept") ? [1] : []
      content {
        items = cookies.value.cookies_config.items
      }
    }
  }

  headers_config {
    header_behavior = each.value.headers_config.header_behavior
    dynamic "headers" {
      for_each = each.value.headers_config.header_behavior == "whitelist" ? [1] : []
      content {
        items = each.value.headers_config.items
      }
    }
  }

  query_strings_config {
    query_string_behavior = each.value.query_strings.query_string_behavior
    dynamic "query_strings" {
      for_each = (each.value.query_strings.query_string_behavior == "whitelist" || each.value.query_strings.query_string_behavior == "allExcept") ? [1] : []
      content {
        items = each.value.query_strings.items
      }
    }
  }
}
data "aws_cloudfront_origin_request_policy" "cloudfront_default_origin_request_policy" {
  for_each = { for value in var.cloudfront_default_origin_request_policies : value.name => value }
  name     = "Managed-${each.value.name}"
}
