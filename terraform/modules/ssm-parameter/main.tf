resource "aws_ssm_parameter" "ssm_parameter" {
  name   = var.name
  value  = var.value
  key_id = var.key_id
  type   = var.type

  tags = {
    Name = var.name
  }
}
