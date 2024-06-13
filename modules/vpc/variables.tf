variable "name" {
    description = "The base name for the resources in this module"
    type        = string
}

variable "region" {
    description = "The AWS region to deploy to"
    type        = string
}

variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    type        = string
}