output "vpc_id" {
    description = "The ID of the VPC"
    value = module.vpc.vpc_id
}

output "database_subnet_group_name" {
    description = "The name of the database subnet group"
    value = module.vpc.database_subnet_group_name
}

output "db_security_group_ids" {
    description = "The security group IDs for the RDS instance"
    value = [aws_security_group.rds.id]
}

output "azs" {
    description = "The availability zones in which the RDS instance will be created"
    value = module.vpc.azs
}

output "public_subnets" {
    description = "The public subnet IDs"
    value = module.vpc.public_subnets
}

output "private_subnets" {
    description = "The private subnet IDs"
    value = module.vpc.private_subnets
}

output "public_subnets_cidr_blocks" {
    description = "The public subnet CIDR blocks"
    value = module.vpc.public_subnets_cidr_blocks
}