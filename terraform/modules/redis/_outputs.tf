#modules/redis/_outputs.tf
output "primary_endpoint_address" {
  value       = aws_elasticache_replication_group.redis_replication_group.primary_endpoint_address
  description = "Address of the endpoint for the primary node in the replication group, if the cluster mode is disabled."
}

output "redis_replication_group_id" {
  value       = aws_elasticache_replication_group.redis_replication_group.id
  description = "ID of the ElastiCache Replication Group."
}

output "reader_endpoint_address" {
  value       = aws_elasticache_replication_group.redis_replication_group.reader_endpoint_address
  description = "Address of the endpoint for the reader node in the replication group, if the cluster mode is disabled."
}

output "member_clusters" {
  value       = tolist(aws_elasticache_replication_group.redis_replication_group.member_clusters)
  description = "Identifiers of all the nodes that are part of this replication group."
}
