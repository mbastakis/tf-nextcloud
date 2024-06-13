variable "name" {
  description = "The base name for the resources in this module"
  type        = string
  default     = "nextcloud-serverless-tf"
}

variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "eu-south-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}