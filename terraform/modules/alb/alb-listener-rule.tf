resource "aws_lb_listener_rule" "alb_listener_rule" {
  for_each = { for value in var.alb_listener_rules : "${value.priority}-${value.condition.type}-${value.action.type}" => value }

  listener_arn = each.value.listener_arn
  priority     = each.value.priority

  dynamic "condition" {
    for_each = each.value.condition.type == "host_header" ? [1] : []
    content {
      host_header {
        values = each.value.condition.values
      }
    }
  }
  dynamic "condition" {
    for_each = each.value.condition.type == "source_ip" ? [1] : []
    content {
      source_ip {
        values = each.value.condition.values
      }
    }
  }
  dynamic "condition" {
    for_each = each.value.condition.type == "path_pattern" ? [1] : []
    content {
      path_pattern {
        values = each.value.condition.values
      }
    }
  }
  dynamic "condition" {
    for_each = each.value.condition.type == "http_request_method" ? [1] : []
    content {
      http_request_method {
        values = each.value.condition.values
      }
    }
  }

  action {
    type             = each.value.action.type
    target_group_arn = each.value.action.forward.target_group_arn #action_type = "forward"
    dynamic "fixed_response" {                                    #action_type = "fixed-response"
      for_each = each.value.action.type == "fixed-response" ? [1] : []
      content {
        content_type = each.value.action.fixed_response.content_type
        status_code  = each.value.action.fixed_response.status_code
        message_body = each.value.action.fixed_response.message_body != null ? data.template_file.action_fixed_response_message_body[each.key].rendered : null
      }
    }
  }

  lifecycle {
    create_before_destroy = false
    ignore_changes = [
      action
    ]
  }
}

data "template_file" "action_fixed_response_message_body" {
  for_each = { for value in var.alb_listener_rules : "${value.priority}-${value.condition.type}-${value.action.type}" => value }
  template = each.value.action.fixed_response.message_body.template
  vars     = each.value.action.fixed_response.message_body.vars
}
