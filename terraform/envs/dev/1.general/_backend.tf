terraform {
  required_version = ">= 1.7.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.91.0"
    }
  }

  backend "s3" {
    profile = "lab-dev"
    bucket  = "lab-dev-iac-state"
    key     = "general/terraform.dev.tfstate"
    region  = "ap-southeast-1"
    encrypt = true
    # use_lockfile = true
  }
}

provider "aws" {
  region  = var.region
  profile = "${var.project}-${var.env}"
  default_tags {
    tags = {
      ManagedBy = "Terraform"
    }
  }
}

provider "aws" {
  alias   = "east"
  region  = "us-east-1"
  profile = "${var.project}-${var.env}"
  default_tags {
    tags = {
      Project   = var.project
      Env       = var.env
      ManagedBy = "Terraform"
    }
  }
}
