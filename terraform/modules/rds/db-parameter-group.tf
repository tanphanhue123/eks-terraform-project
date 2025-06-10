resource "aws_rds_cluster_parameter_group" "aurora_cluster_parameter_group" {
  name        = "${var.project}-${var.env}-${var.name}-cluster-parameter-group"
  description = "Parameter Group - ${var.project}-${var.env}-${var.name}-cluster-parameter-group"
  family      = var.aurora_parameter_group.family

  dynamic "parameter" {
    for_each = var.aurora_parameter_group.cluster_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = {
    Name = "${var.project}-${var.env}-${var.name}-cluster-parameter-group"
  }
}

resource "aws_db_parameter_group" "aurora_parameter_group" {
  name        = "${var.project}-${var.env}-${var.name}-parameter-group"
  description = "Parameter Group - ${var.project}-${var.env}-${var.name}-parameter-group"
  family      = var.aurora_parameter_group.family

  dynamic "parameter" {
    for_each = var.aurora_parameter_group.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = {
    Name = "${var.project}-${var.env}-${var.name}-parameter-group"
  }
}
