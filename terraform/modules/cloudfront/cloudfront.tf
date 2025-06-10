resource "aws_cloudfront_distribution" "cloudfront" {
  comment             = "${var.project}-${var.env}-${var.cloudfront_name}-cloudfront-distribution"
  enabled             = true
  wait_for_deployment = true
  is_ipv6_enabled     = false
  price_class         = var.cloudfront_price_class
  default_root_object = var.cloudfront_default_root_object
  aliases             = var.cloudfront_aliases_domain #domain
  web_acl_id          = var.cloudfront_web_acl_id     #waf

  #Logging
  dynamic "logging_config" {
    for_each = var.cloudfront_logging_config_s3_bucket_domain_name != null ? [1] : []

    content {
      bucket          = var.cloudfront_logging_config_s3_bucket_domain_name
      prefix          = "CF-Logs/${var.cloudfront_name}"
      include_cookies = false
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.cloudfront_viewer_certificate.cloudfront_default_certificate
    acm_certificate_arn            = var.cloudfront_viewer_certificate.acm_certificate_arn
    ssl_support_method             = var.cloudfront_viewer_certificate.acm_certificate_arn != null ? var.cloudfront_viewer_certificate.ssl_support_method : null
    minimum_protocol_version       = var.cloudfront_viewer_certificate.acm_certificate_arn != null ? var.cloudfront_viewer_certificate.minimum_protocol_version : null
  }

  restrictions {
    dynamic "geo_restriction" {
      for_each = [var.cloudfront_geo_restriction]
      content {
        restriction_type = geo_restriction.value.restriction_type
        locations        = geo_restriction.value.locations
      }
    }
  }

  #Origin
  dynamic "origin" {
    for_each = var.cloudfront_origins
    content {
      domain_name              = origin.value.domain_name
      origin_id                = origin.value.origin_id
      origin_access_control_id = origin.value.s3_origin_config == true ? aws_cloudfront_origin_access_control.cloudfront_oac[0].id : null
      dynamic "custom_origin_config" {
        for_each = origin.value.custom_origin_config != null ? [origin.value.custom_origin_config] : []
        content {
          http_port                = custom_origin_config.value.http_port
          https_port               = custom_origin_config.value.https_port
          origin_protocol_policy   = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols     = custom_origin_config.value.origin_ssl_protocols
          origin_keepalive_timeout = custom_origin_config.value.origin_keepalive_timeout
          origin_read_timeout      = custom_origin_config.value.origin_read_timeout
        }
      }
      dynamic "custom_header" {
        for_each = origin.value.custom_header
        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.cloudfront_ordered_cache_behaviors

    content {
      target_origin_id           = ordered_cache_behavior.value.target_origin_id
      path_pattern               = ordered_cache_behavior.value.path_pattern
      viewer_protocol_policy     = ordered_cache_behavior.value.viewer_protocol_policy
      allowed_methods            = ordered_cache_behavior.value.allowed_methods
      cached_methods             = ordered_cache_behavior.value.cached_methods
      compress                   = ordered_cache_behavior.value.compress
      trusted_key_groups         = ordered_cache_behavior.value.trusted_key_groups != false ? [aws_cloudfront_key_group.cloudfront_key_group[0].id] : []
      cache_policy_id            = ordered_cache_behavior.value.cache_policy_id
      response_headers_policy_id = ordered_cache_behavior.value.response_headers_policy_id
      origin_request_policy_id   = ordered_cache_behavior.value.origin_request_policy_id

      # Associate lambda function to CF
      dynamic "lambda_function_association" {
        for_each = ordered_cache_behavior.value.lambda_function_associations

        content {
          event_type   = lambda_function_association.value.event_type
          lambda_arn   = lambda_function_association.value.lambda_arn
          include_body = lambda_function_association.value.include_body
        }
      }

      # Associate Cloudfront function to CF
      dynamic "function_association" {
        for_each = ordered_cache_behavior.value.function_associations

        content {
          event_type   = function_association.value.event_type
          function_arn = function_association.value.function_arn
        }
      }
    }
  }

  #Default cache behavior
  dynamic "default_cache_behavior" {
    for_each = [var.cloudfront_default_cache_behavior]

    content {
      target_origin_id           = var.cloudfront_default_cache_behavior.target_origin_id
      viewer_protocol_policy     = var.cloudfront_default_cache_behavior.viewer_protocol_policy
      allowed_methods            = var.cloudfront_default_cache_behavior.allowed_methods
      cached_methods             = var.cloudfront_default_cache_behavior.cached_methods
      compress                   = var.cloudfront_default_cache_behavior.compress
      trusted_key_groups         = var.cloudfront_default_cache_behavior.trusted_key_groups != false ? [aws_cloudfront_key_group.cloudfront_key_group[0].id] : []
      cache_policy_id            = var.cloudfront_default_cache_behavior.cache_policy_id
      response_headers_policy_id = var.cloudfront_default_cache_behavior.response_headers_policy_id
      origin_request_policy_id   = var.cloudfront_default_cache_behavior.origin_request_policy_id

      # Associate lambda function to CF
      dynamic "lambda_function_association" {
        for_each = var.cloudfront_default_cache_behavior.lambda_function_associations

        content {
          event_type   = lambda_function_association.value.event_type
          lambda_arn   = lambda_function_association.value.lambda_arn
          include_body = lambda_function_association.value.include_body
        }
      }

      # Associate Cloudfront function to CF
      dynamic "function_association" {
        for_each = var.cloudfront_default_cache_behavior.function_associations

        content {
          event_type   = function_association.value.event_type
          function_arn = function_association.value.function_arn
        }
      }
    }
  }

  dynamic "custom_error_response" {
    for_each = var.cloudfront_custom_error_responses

    content {
      error_code            = custom_error_response.value.error_code
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }

  tags = {
    Name = "${var.project}-${var.env}-${var.cloudfront_name}-cloudfront-distribution"
  }
}
