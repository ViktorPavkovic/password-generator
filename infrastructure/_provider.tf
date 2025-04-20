terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # backend "s3" {
  #   bucket = "[ACCOUNT_ID]-terraform"
  #   key    = "[PROJECT]/[ENV]/terraform.tfstate"
  #   region = "[REGION]"

  #   encrypt      = true
  #   use_lockfile = true
  # }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = var.project
      Environment = var.env
      Provider    = "Terraform"
    }
  }
}
