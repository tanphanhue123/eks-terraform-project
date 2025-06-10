resource "aws_lb" "alb" {
  name                       = "${var.project}-${var.env}-alb-${var.type}"
  load_balancer_type         = "application"
  internal                   = var.alb.internal
  drop_invalid_header_fields = false
  enable_deletion_protection = false
  enable_http2               = true
  idle_timeout               = 60

  security_groups = var.alb.security_group_ids
  subnets         = var.alb.subnet_ids

  tags = {
    Name = "${var.project}-${var.env}-alb-${var.type}"
    Type = var.type
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  for_each = { for value in var.alb_target_group.target_groups : value.name => value }

  vpc_id      = var.alb_target_group.vpc_id
  name        = "${var.project}-${var.env}-alb-${var.type}-${each.value.name}"
  target_type = each.value.target_type

  port                          = each.value.port
  protocol                      = "HTTP"
  protocol_version              = "HTTP1"
  proxy_protocol_v2             = false
  deregistration_delay          = each.value.deregistration_delay
  slow_start                    = 0
  load_balancing_algorithm_type = "round_robin"

  health_check {
    enabled             = true
    port                = each.value.health_check.port
    protocol            = "HTTP"
    path                = each.value.health_check.path
    healthy_threshold   = each.value.health_check.healthy_threshold
    unhealthy_threshold = each.value.health_check.unhealthy_threshold
    interval            = each.value.health_check.interval
    timeout             = each.value.health_check.timeout
    matcher             = each.value.health_check.matcher
  }

  tags = {
    Name = "${var.project}-${var.env}-alb-${var.type}-${each.value.name}-tgr"
    Type = var.type
  }
}
