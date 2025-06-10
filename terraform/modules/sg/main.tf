resource "aws_security_group" "main" {
  name        = "${var.project}-${var.env}-sg-${var.name}"
  vpc_id      = var.vpc_id
  description = "${var.project}-${var.env}-sg-${var.name}"

  dynamic "ingress" {
    for_each = var.ingress

    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      security_groups = ingress.value.security_groups
      cidr_blocks     = ingress.value.cidr_blocks
      prefix_list_ids = ingress.value.prefix_list_ids
      description     = ingress.value.description
      self            = ingress.value.self
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project}-${var.env}-sg-${var.name}"
  })
}
