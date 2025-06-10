########################
# Cluster fargate profile
########################
resource "aws_eks_fargate_profile" "eks_fargate_profile" {
  for_each = { for value in var.fargate_profiles : value.fargate_profile_name => value }

  cluster_name           = aws_eks_cluster.eks_cluster.name
  fargate_profile_name   = "${var.project}-${var.env}-eks-${each.value.fargate_profile_name}-fargate-profile"
  pod_execution_role_arn = each.value.pod_execution_role_arn
  subnet_ids             = each.value.subnet_ids

  dynamic "selector" {
    for_each = each.value.selectors
    content {
      namespace = selector.value.namespace
      labels    = selector.value.labels
    }
  }

  #timeout
  timeouts {
    create = each.value.timeouts.create
    delete = each.value.timeouts.delete
  }

  tags = {
    Name = "${var.project}-${var.env}-eks-${each.value.fargate_profile_name}-fargate-profile"
  }
}
