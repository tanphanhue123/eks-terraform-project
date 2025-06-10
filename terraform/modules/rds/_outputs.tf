#modules/rds-aurora/_outputs.tf
output "aurora_cluster_name" {
  description = "The RDS Cluster Name"
  value       = aws_rds_cluster.aurora_cluster.id
}
output "aurora_cluster_identifier" {
  description = "The RDS Cluster Identifier"
  value       = aws_rds_cluster.aurora_cluster.cluster_identifier
}
output "aurora_cluster_endpoint" {
  description = "The DNS address of the RDS instance"
  value       = aws_rds_cluster.aurora_cluster.endpoint
}
