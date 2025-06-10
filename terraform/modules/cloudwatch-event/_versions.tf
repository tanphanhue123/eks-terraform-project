#modules/cloudwatch-event/_versions.tf
terraform {
  required_version = ">= 1.3.9"

  required_providers {
    template = "~> 2.2.0"
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.48"
    }
  }
}
