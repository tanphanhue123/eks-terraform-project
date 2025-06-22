module "security_group_eks_cluster" {
  source = "../../../modules/sg"
  #basic
  env     = var.env
  project = var.project

  #security_group
  name   = "eks-cluster-sg"
  vpc_id = data.terraform_remote_state.general.outputs.vpc_id
  ingress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Custom EKS Cluster Security Group"
      self        = true
    }
  ]
  tags = {
    "karpenter.sh/discovery" = "${var.project}-${var.env}-eks-pet-cluster"
  }
}
