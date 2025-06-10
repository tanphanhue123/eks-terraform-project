resource "aws_eks_pod_identity_association" "aws_eks_pod_identity_association" {
  for_each        = { for value in var.pod_identity_association : value.service_account => value }
  cluster_name    = aws_eks_cluster.eks_cluster.name
  namespace       = each.value.namespace
  service_account = each.value.service_account
  role_arn        = each.value.role_arn
  tags = {
    Name = "${var.project}-${var.env}-${each.value.service_account}-pod-identity-association"
  }
}