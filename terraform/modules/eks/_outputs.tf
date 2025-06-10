#modules/eks/_outputs.tf
output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}
output "eks_cluster_id" {
  description = "The ID of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.id
}
output "eks_cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.arn
}
output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.endpoint
}
output "eks_cluster_certificate_authority" {
  description = "The Cert of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}
output "aws_iam_openid_connect_provider_eks_cluster_url" {
  description = "The url OIDC of the EKS cluster"
  value       = aws_iam_openid_connect_provider.eks_cluster.url
}
output "aws_iam_openid_connect_provider_eks_cluster_arn" {
  description = "The arn OIDC of the EKS cluster"
  value       = aws_iam_openid_connect_provider.eks_cluster.arn
}

#EKS security group
output "eks_cluster_security_group_id" {
  description = "Amazon Resource Name (ARN) identifying fargate profile eks"
  value       = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}

#Addons
output "eks_cluster_addons_arn" {
  description = "Amazon Resource Name (ARN) identifying your addons eks"
  value       = { for key, value in aws_eks_addon.eks_addon : key => value.arn }
}
output "eks_cluster_addons_id" {
  description = "Amazon Resource Name (ARN) identifying your addons eks"
  value       = { for key, value in aws_eks_addon.eks_addon : key => value.id }
}

#Fargate profile
output "eks_cluster_fargate_profile_arn" {
  description = "Amazon Resource Name (ARN) identifying fargate profile eks"
  value       = { for key, value in aws_eks_fargate_profile.eks_fargate_profile : key => value.arn }
}
output "eks_cluster_fargate_profile_id" {
  description = "Name identifying fargate profile eks"
  value       = { for key, value in aws_eks_fargate_profile.eks_fargate_profile : key => value.id }
}

#Node group
output "eks_cluster_node_group_arn" {
  description = "Amazon Resource Name (ARN) identifying node group eks"
  value       = { for key, value in aws_eks_node_group.eks_node_group : key => value.arn }
}
output "eks_cluster_node_group_id" {
  description = "Name identifying node group eks"
  value       = { for key, value in aws_eks_node_group.eks_node_group : key => value.id }
}
output "eks_cluster_node_group_resources" {
  description = "Resource identifying node group eks"
  value       = { for key, value in aws_eks_node_group.eks_node_group : key => value.resources }
}
