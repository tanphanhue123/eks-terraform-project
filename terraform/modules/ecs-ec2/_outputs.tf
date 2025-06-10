output "ecs_cluster_id" {
  description = "ARN that identifies the cluster"
  value       =  resource.aws_ecs_cluster.aws_ecs_cluster.id
}