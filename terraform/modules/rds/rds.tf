resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier = "${var.project}-${var.env}-${var.name}-cluster"
  engine             = var.aurora_cluster.engine
  engine_version     = var.aurora_cluster.engine_version
  database_name      = var.aurora_cluster.database_name
  master_username    = var.aurora_cluster.master_username
  master_password    = var.aurora_cluster.master_password

  skip_final_snapshot       = var.aurora_cluster.skip_final_snapshot
  final_snapshot_identifier = "${var.project}-${var.env}-${var.name}-cluster-final-snapshot"
  copy_tags_to_snapshot     = var.aurora_cluster.copy_tags_to_snapshot
  backup_retention_period   = var.aurora_cluster.backup_retention_period

  preferred_backup_window      = var.aurora_cluster.preferred_backup_window
  preferred_maintenance_window = var.aurora_cluster.preferred_maintenance_window

  vpc_security_group_ids          = var.aurora_cluster.security_group_ids
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_parameter_group.id
  db_subnet_group_name            = aws_db_subnet_group.aurora_subnet_group.id
  port                            = var.aurora_cluster.port
  apply_immediately               = var.aurora_cluster.apply_immediately
  enabled_cloudwatch_logs_exports = var.aurora_cluster.enable_cloudwatch_logs

  storage_encrypted           = var.aurora_cluster.storage_encrypted
  kms_key_id                  = var.aurora_cluster.kms_key_id
  allow_major_version_upgrade = var.aurora_cluster.allow_major_version_upgrade

  tags = {
    Name = "${var.project}-${var.env}-${var.name}-cluster"
  }
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  count = var.aurora_instance.number

  engine                       = aws_rds_cluster.aurora_cluster.engine
  engine_version               = aws_rds_cluster.aurora_cluster.engine_version
  cluster_identifier           = aws_rds_cluster.aurora_cluster.id
  identifier                   = "${var.project}-${var.env}-${var.name}-instance-${count.index + 1}"
  instance_class               = var.aurora_instance.instance_class
  db_parameter_group_name      = aws_db_parameter_group.aurora_parameter_group.id
  db_subnet_group_name         = aws_db_subnet_group.aurora_subnet_group.id
  copy_tags_to_snapshot        = var.aurora_instance.copy_tags_to_snapshot
  apply_immediately            = var.aurora_instance.apply_immediately
  auto_minor_version_upgrade   = var.aurora_instance.auto_minor_version_upgrade
  publicly_accessible          = var.aurora_instance.publicly_accessible
  performance_insights_enabled = var.aurora_instance.performance_insights_enabled
  monitoring_interval          = var.aurora_instance.monitoring_interval
  monitoring_role_arn          = var.aurora_instance.monitoring_interval > 0 ? var.aurora_instance.monitoring_role_arn : null

  tags = {
    Name = "${var.project}-${var.env}-${var.name}-instance-${count.index + 1}"
  }
}
