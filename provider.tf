terraform {

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.42"
    }
  }

  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}
