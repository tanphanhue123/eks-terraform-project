#modules/ssm-parameter/_versions.tf
terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37"
    }
  }
}
