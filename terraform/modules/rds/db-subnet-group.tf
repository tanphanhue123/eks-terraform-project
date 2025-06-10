resource "aws_db_subnet_group" "aurora_subnet_group" {
  name        = "${var.project}-${var.env}-${var.name}-subnet-group"
  description = "Subnet Group - ${var.project}-${var.env}-${var.name}-subnet-group"
  subnet_ids  = var.aurora_subnet_ids

  tags = {
    Name = "${var.project}-${var.env}-${var.name}-subnet-group"
  }
}
