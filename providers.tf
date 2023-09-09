# configure aws provider
provider "aws" {
  region    = var.region
  profile   = var.aws_profile
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.14.0"
    }
  }
}
