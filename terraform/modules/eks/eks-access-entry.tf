resource "aws_eks_access_entry" "eks_access_entry" {
  #   for_each          = { for value in var.eks_access_entry : value.principal_arn => value }
  for_each          = { for index, value in var.eks_access_entry : tostring(index) => value }
  cluster_name      = aws_eks_cluster.eks_cluster.name
  principal_arn     = each.value.principal_arn
  type              = each.value.type
  kubernetes_groups = each.value.kubernetes_groups
  user_name         = each.value.user_name
  tags              = each.value.tags
}

resource "aws_eks_access_policy_association" "eks_access_policy_association" {
  #   for_each      = { for value in var.eks_access_policy_association : value.principal_arn => value }
  for_each      = { for index, value in var.eks_access_policy_association : tostring(index) => value }
  cluster_name  = aws_eks_cluster.eks_cluster.name
  policy_arn    = each.value.policy_arn
  principal_arn = each.value.principal_arn

  access_scope {
    type       = each.value.access_scope.type
    namespaces = each.value.access_scope.namespaces
  }
}