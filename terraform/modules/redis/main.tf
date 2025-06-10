resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name        = "${var.project}-${var.env}-${var.redis_name}-subnet-group"
  description = "${var.project}-${var.env}-${var.redis_name}-subnet-group for the redis instances"
  subnet_ids  = var.redis_subnet_ids
}

resource "aws_elasticache_replication_group" "redis_replication_group" {
  automatic_failover_enabled = var.redis_replication_group.number_cache_clusters > 1 ? true : false
  multi_az_enabled           = var.redis_replication_group.number_cache_clusters > 1 ? true : false
  replication_group_id       = "${var.project}-${var.env}-${var.redis_name}-repl-group"
  description                = "ElastiCache with redis for ${var.project} ${var.env}"
  node_type                  = var.redis_replication_group.node_type
  num_cache_clusters         = var.redis_replication_group.number_cache_clusters
  parameter_group_name       = aws_elasticache_parameter_group.default.id
  engine_version             = var.redis_replication_group.engine_version
  security_group_ids         = var.redis_replication_group.security_group_ids
  subnet_group_name          = aws_elasticache_subnet_group.redis_subnet_group.name
  maintenance_window         = var.redis_replication_group.maintenance_window
  apply_immediately          = true
  port                       = "6379"
  snapshot_window            = var.redis_replication_group.snapshot_window
  snapshot_retention_limit   = var.redis_replication_group.snapshot_retention_limit
  notification_topic_arn     = var.redis_replication_group.sns_topic_arn
  auto_minor_version_upgrade = true

  tags = {
    Name = "${var.project}-${var.env}-${var.redis_name}-repl-group"
  }
}
