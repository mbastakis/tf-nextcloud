terraform {
  backend "s3" {}
  required_providers {
    aws    = "~> 2.13"
  }

}

provider "aws" {
  region = var.aws_region
}
