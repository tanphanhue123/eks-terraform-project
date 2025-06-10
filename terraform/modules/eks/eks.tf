###################
# EKS Cluster
###################
resource "aws_eks_cluster" "eks_cluster" {
  name                      = "${var.project}-${var.env}-eks-${var.eks.name}-cluster"
  role_arn                  = var.eks.role_arn
  version                   = var.eks.version
  enabled_cluster_log_types = var.eks.enabled_cluster_log_types

  vpc_config {
    endpoint_private_access = var.eks.vpc_config.endpoint_private_access
    endpoint_public_access  = var.eks.vpc_config.endpoint_public_access
    public_access_cidrs     = var.eks.vpc_config.public_access_cidrs
    security_group_ids      = var.eks.vpc_config.security_group_ids
    subnet_ids              = var.eks.vpc_config.subnet_ids
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = "false"
  }

  dynamic "encryption_config" {
    for_each = var.eks.encryption_config != null ? [var.eks.encryption_config] : []
    content {
      resources = encryption_config.value.resources
      provider {
        key_arn = encryption_config.value.provider.key_arn
      }
    }
  }

  dynamic "kubernetes_network_config" {
    for_each = var.eks.kubernetes_network_config != null ? [var.eks.kubernetes_network_config] : []
    content {
      service_ipv4_cidr = kubernetes_network_config.value.service_ipv4_cidr
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.eks_log_group
  ]

  timeouts {
    create = var.eks.timeouts.create
    delete = var.eks.timeouts.delete
    update = var.eks.timeouts.update
  }

  lifecycle {
    ignore_changes = []
  }

  tags = {
    Name = "${var.project}-${var.env}-eks-${var.eks.name}-cluster"
  }
}
