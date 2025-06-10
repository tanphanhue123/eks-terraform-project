###############################################################################
#ALB Ingress Controller Helm charts
###############################################################################

resource "helm_release" "aws_lbc" {
  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.12.0"

  set {
    name  = "clusterName"
    value = module.eks_cluster.eks_cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "vpcId"
    value = data.terraform_remote_state.general.outputs.vpc_id
  }

  depends_on = [module.eks_cluster]
}