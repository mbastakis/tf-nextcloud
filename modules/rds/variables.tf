variable "name" {
  description = "The name of the RDS instance"
  type        = string
}

variable "region" {
    description = "The region in which the RDS instance will be created"
    type        = string
}

variable "vpc_cidr" {
    description = "The CIDR block of the VPC"
    type        = string
}

variable "available_zones" {
    description = "The availability zones in which the RDS instance will be created"
    type        = list(string)
}

variable "db_username" {
    description = "The username for the RDS instance"
    type        = string
}

variable "db_password" {
    description = "The password for the RDS instance"
    type        = string
}

variable "vpc_id" {
    description = "The ID of the VPC"
    type        = string
}

variable "db_subnet_group_name" {
    description = "The name of the database subnet group"
    type        = string
}

variable "security_group_rules" {
    description = "The security group rules for the VPC endpoints"
    type        = map(object({
        description = string
        cidr_blocks = list(string)
    }))
}