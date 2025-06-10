###############################################################################
# VPC
###############################################################################
module "vpc-eks" {
  source = "../../../modules/vpc-eks"
  #basic
  env     = var.env
  project = var.project
  region  = var.region

  #vpc
  vpc_cidr      = var.cidr.vpc
  public_cidrs  = var.cidr.publics
  private_cidrs = var.cidr.privates
  private_subnet_tags = {
    "karpenter.sh/discovery" = "${var.project}-${var.env}-eks-pet-cluster"
  }
  only_one_nat_gateway = true
}
