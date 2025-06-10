resource "aws_cloudwatch_log_group" "aurora_log_group" {
  for_each = toset(var.aurora_cluster.enable_cloudwatch_logs)

  name              = "/aws/rds/cluster/${aws_rds_cluster.aurora_cluster.cluster_identifier}/${each.value}"
  retention_in_days = var.aurora_log_group_retention

  tags = {
    Name = "${var.project}-${var.env}-${var.name}-cluster"
  }
}
