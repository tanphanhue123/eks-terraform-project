###################
# EKS cloudwatch log group
###################
resource "aws_cloudwatch_log_group" "eks_log_group" {
  count = length(var.eks.enabled_cluster_log_types) > 0 ? 1 : 0

  name              = "/aws/eks/${var.project}-${var.env}-eks-${var.eks.name}-cluster/cluster"
  retention_in_days = var.eks_log_group_retention

  tags = {
    Name = "/aws/eks/${var.project}-${var.env}-eks-${var.eks.name}-cluster/cluster"
  }
}
