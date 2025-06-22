data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "eks" {
  name = module.eks_cluster.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks_cluster.eks_cluster_name
}

data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

data "aws_ssm_parameter" "alert_webhook" {
  name = "/${var.env}/alert-webhook"
}

data "aws_ssm_parameter" "argocd_token" {
  name = "/${var.env}/argocd-token"
}

data "aws_ssm_parameter" "grafana_admin_password" {
  name = "/${var.env}/grafana-admin-password"
}
data "terraform_remote_state" "general" {
  backend = "s3"
  config = {
    profile = "${var.project}-${var.env}"
    bucket  = "${var.project}-${var.env}-iac-state"
    key     = "general/terraform.${var.env}.tfstate"
    region  = var.region
  }
}
