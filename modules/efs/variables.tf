variable "name" {
    description = "The name of the EFS service"
    type        = string
}

variable "vpc_id" {
    description = "The VPC ID"
    type        = string
}

variable "public_subnets" {
    description = "The public subnet IDs"
    type        = list(string)
}

variable "available_zones" {
    description = "The available zones"
    type        = list(string)
}

variable "public_subnets_cidr_blocks" {
    description = "The public subnet CIDR blocks"
    type        = list(string)
}