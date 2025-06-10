resource "aws_flow_log" "vpc_flow_log" {
  for_each = var.vpc_flow_logs

  vpc_id                   = aws_vpc.vpc.id
  log_destination          = each.value.log_destination_arn
  log_destination_type     = each.value.log_destination_type
  traffic_type             = each.value.traffic_type
  max_aggregation_interval = 600

  tags = {
    Name = "${var.project}-${var.env}-vpc-flow-log-${each.value.log_destination_type}"
  }
}
