module "eks_cluster" {
  source = "../../../modules/eks"
  #basic
  env     = var.env
  project = var.project

  #eks_nodegroup
  eks = {
    name     = "pet"
    role_arn = module.iam_role_eks_cluster.iam_role_arn
    version  = "1.32"

    kubernetes_network_config = {
      service_ipv4_cidr = "10.160.0.0/16"
    }
    vpc_config = {
      endpoint_private_access = "true"
      endpoint_public_access  = "true"
      # public_access_cidrs     = concat(var.global_ips.sun_hni, var.global_ips.sun_dng)
      public_access_cidrs = ["0.0.0.0/0"]
      security_group_ids  = [module.security_group_eks_cluster.sg_id]
      subnet_ids          = data.terraform_remote_state.general.outputs.subnet_private_id
    }
  }

  eks_node_group = [
    {
      node_group_name = "karpenter"
      node_role_arn   = module.iam_role_node_group.iam_role_arn
      subnet_ids      = data.terraform_remote_state.general.outputs.subnet_private_id
      scaling_config = {
        desired_size = 3
        min_size     = 3
        max_size     = 4
      }
      instance_types = ["t3.medium"]
      labels = {
        "karpenter.sh/controller" = "true"
      }
    }
  ]

  eks_addons = [
    {
      addon_name    = "vpc-cni"
      addon_version = "v1.19.2-eksbuild.1"
    },
    {
      addon_name    = "eks-pod-identity-agent"
      addon_version = "v1.3.4-eksbuild.1"
    },
    {
      addon_name    = "coredns"
      addon_version = "v1.11.4-eksbuild.10"
    },
    {
      addon_name    = "metrics-server"
      addon_version = "v0.7.2-eksbuild.3"
    },
    {
      addon_name    = "aws-ebs-csi-driver"
      addon_version = "v1.41.0-eksbuild.1"
    }
  ]

  pod_identity_association = [
    {
      namespace       = "kube-system"
      service_account = "aws-node"
      role_arn        = module.iam_role_vpc_cni.iam_role_arn
    },
    {
      namespace       = "kube-system"
      service_account = "ebs-csi-controller-sa"
      role_arn        = module.iam_role_ebs_csi_driver.iam_role_arn
    },
    {
      namespace       = "karpenter"
      service_account = "karpenter"
      role_arn        = module.iam_role_karpenter.iam_role_arn
    },
    {
      namespace       = "kube-system"
      service_account = "aws-load-balancer-controller"
      role_arn        = module.iam_role_eks_lb_controller.iam_role_arn
    },
    {
      namespace       = "external-secrets"
      service_account = "external-secrets"
      role_arn        = module.iam_role_external_secret.iam_role_arn
    },
    {
      namespace       = "logging"
      service_account = "loki"
      role_arn        = module.iam_role_loki.iam_role_arn
    }
  ]

  eks_access_entry = [
    {
      principal_arn = data.aws_caller_identity.current.arn
      type          = "STANDARD"
    }
  ]
  eks_access_policy_association = [
    {
      principal_arn = data.aws_caller_identity.current.arn
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      access_scope = {
        type = "cluster"
      }
    }
  ]
}
