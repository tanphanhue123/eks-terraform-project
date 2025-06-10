resource "aws_eip" "ec2_eip" {
  # vpc      = true
  instance = var.ec2_instance_id
  tags = {
    Name = "${var.project}-${var.env}-eip-${var.type}-${var.env}"
    Type = var.type
  }
}
