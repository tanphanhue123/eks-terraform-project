resource "aws_elasticache_parameter_group" "default" {
  name        = "${var.project}-${var.env}-${var.redis_name}-parameter-group"
  description = "Parameter Group - ${var.project}-${var.env}-${var.redis_name}-parameter-group"
  family      = var.redis_parameters.family

  dynamic "parameter" {
    for_each = var.redis_parameters.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = {
    Name = "${var.project}-${var.env}-${var.redis_name}-parameter-group"
  }
}
