########################
# Cluster node group
########################
resource "aws_eks_node_group" "eks_node_group" {
  for_each = { for value in var.eks_node_group : value.node_group_name => value }

  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.project}-${var.env}-eks-${each.value.node_group_name}-node-group"
  node_role_arn   = each.value.node_role_arn
  subnet_ids      = each.value.subnet_ids

  scaling_config {
    desired_size = each.value.scaling_config.desired_size
    min_size     = each.value.scaling_config.min_size
    max_size     = each.value.scaling_config.max_size
  }

  dynamic "update_config" {
    for_each = each.value.update_config != null ? [1] : []
    content {
      max_unavailable            = each.value.update_config.max_unavailable != null ? each.value.update_config.max_unavailable : null
      max_unavailable_percentage = each.value.update_config.max_unavailable_percentage != null ? each.value.update_config.max_unavailable_percentage : null
    }
  }

  ami_type             = each.value.ami_type
  capacity_type        = each.value.capacity_type
  disk_size            = each.value.launch_template != null ? null : each.value.disk_size
  force_update_version = each.value.force_update_version
  instance_types       = each.value.launch_template != null ? null : each.value.instance_types
  labels               = each.value.labels
  version              = each.value.ami_type != null ? null : each.value.version
  release_version      = each.value.ami_type != null ? null : each.value.release_version

  dynamic "launch_template" {
    for_each = each.value.launch_template != null ? [1] : []
    content {
      name    = each.value.launch_template.name
      version = each.value.launch_template.version
    }
  }

  dynamic "remote_access" {
    for_each = each.value.remote_access != null ? [1] : []
    content {
      ec2_ssh_key               = each.value.remote_access.ec2_ssh_key
      source_security_group_ids = each.value.remote_access.source_security_group_ids
    }
  }

  dynamic "taint" {
    for_each = each.value.taint
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]

  timeouts {
    create = each.value.timeouts.create
    update = each.value.timeouts.update
    delete = each.value.timeouts.delete
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }

  tags = {
    Name = "${var.project}-${var.env}-eks-${each.value.node_group_name}-node-group"
  }
}
