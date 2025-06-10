resource "aws_wafv2_web_acl" "wafv2_web_acl" {
  name        = "${var.project}-${var.env}-${var.wafv2_web_acl_name}-wafv2-web-acl"
  description = "WAF ACL for ${var.wafv2_web_acl_name} on ${var.env} Environment of ${var.project} project"
  scope       = var.wafv2_scope

  default_action {
    dynamic "allow" {
      for_each = var.wafv2_web_acl_default_action == "allow" ? [1] : []
      content {}
    }
    dynamic "block" {
      for_each = var.wafv2_web_acl_default_action == "block" ? [1] : []
      content {}
    }
  }

  # Define rule
  dynamic "rule" {
    for_each = var.wafv2_web_acl_rules
    content {
      priority = rule.value.priority
      name     = "${rule.value.name}-rule"

      statement {
        dynamic "managed_rule_group_statement" {
          for_each = lookup(rule.value, "ip_set_reference_statement", {}) == {} && lookup(rule.value, "byte_match_statement", []) == [] && lookup(rule.value, "rate_based_statement", {}) == {} ? [1] : []
          content {
            name        = rule.value.name
            vendor_name = "AWS"
            dynamic "rule_action_override" {
              for_each = lookup(rule.value, "rule_action_override", [])
              content {
                name = rule_action_override.value
                action_to_use {
                  count {}
                }
              }
            }
          }
        }
        dynamic "ip_set_reference_statement" {
          for_each = lookup(rule.value, "ip_set_reference_statement", {}) != {} ? [rule.value.ip_set_reference_statement] : []
          content {
            arn = aws_wafv2_ip_set.wafv2_ip_set[rule.value.name].arn
          }
        }
        dynamic "byte_match_statement" {
          for_each = lookup(rule.value, "byte_match_statement", {}) != {} ? [rule.value.byte_match_statement] : []
          content {
            positional_constraint = byte_match_statement.value.positional_constraint
            search_string         = byte_match_statement.value.search_string
            field_to_match {
              uri_path {}
            }
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }

      dynamic "override_action" {
        for_each = lookup(rule.value, "ip_set_reference_statement", {}) == {} && lookup(rule.value, "byte_match_statement", []) == [] && lookup(rule.value, "rate_based_statement", {}) == {} ? [1] : []
        content {
          none {}
        }
      }

      dynamic "action" {
        for_each = lookup(rule.value, "ip_set_reference_statement", {}) != {} ? [1] : []
        content {
          dynamic "allow" {
            for_each = rule.value.ip_set_reference_statement.action == "allow" ? [1] : []
            content {}
          }
          dynamic "block" {
            for_each = rule.value.ip_set_reference_statement.action == "block" ? [1] : []
            content {}
          }
        }
      }
      dynamic "action" {
        for_each = lookup(rule.value, "byte_match_statement", {}) != {} ? [1] : []
        content {
          dynamic "allow" {
            for_each = rule.value.byte_match_statement.action == "allow" ? [1] : []
            content {}
          }
          dynamic "block" {
            for_each = rule.value.byte_match_statement.action == "block" ? [1] : []
            content {}
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${rule.value.name}-rule-metric"
        sampled_requests_enabled   = true
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project}-${var.env}-${var.wafv2_web_acl_name}-wafv2-web-acl-metric"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "${var.project}-${var.env}-${var.wafv2_web_acl_name}-wafv2-web-acl"
  }
}

resource "aws_wafv2_web_acl_association" "wafv2_web_acl_association" {
  count = var.wafv2_web_acl_association != [] ? 1 : 0

  resource_arn = var.wafv2_web_acl_association
  web_acl_arn  = aws_wafv2_web_acl.wafv2_web_acl.arn
}

resource "aws_wafv2_web_acl_logging_configuration" "wafv2_web_acl_logging" {
  count = var.wafv2_web_acl_logging != {} ? 1 : 0

  log_destination_configs = var.wafv2_web_acl_logging.destination_arn
  resource_arn            = aws_wafv2_web_acl.wafv2_web_acl.arn
}
