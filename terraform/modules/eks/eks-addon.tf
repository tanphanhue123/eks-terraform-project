###################
# EKS Cluster Addons
###################
resource "aws_eks_addon" "eks_addon" {
  for_each = { for value in var.eks_addons : value.addon_name => value }

  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = each.value.addon_name
  addon_version               = each.value.addon_version
  configuration_values        = each.value.configuration_values
  resolve_conflicts_on_create = each.value.resolve_conflicts_on_create
  resolve_conflicts_on_update = each.value.resolve_conflicts_on_update
  preserve                    = each.value.preserve
  service_account_role_arn    = each.value.service_account_role_arn
  dynamic "pod_identity_association" {
    for_each = each.value.pod_identity_association != null ? [each.value.pod_identity_association] : []
    content {
      role_arn        = pod_identity_association.value.role_arn
      service_account = pod_identity_association.value.service_account
    }
  }
  #timeout
  timeouts {
    create = each.value.timeouts.create
    update = each.value.timeouts.update
    delete = each.value.timeouts.delete
  }

  depends_on = [
    aws_eks_fargate_profile.eks_fargate_profile, aws_eks_cluster.eks_cluster
  ]
}
