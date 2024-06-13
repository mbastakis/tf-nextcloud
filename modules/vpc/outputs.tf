output "vpc_id" {
    description = "The ID of the VPC"
    value = module.vpc.vpc_id
}

output "database_subnet_group_name" {
    description = "The name of the database subnet group"
    value = module.vpc.database_subnet_group_name
}

output "db_security_group_rules" {
    description = "The security group rules for the VPC endpoints"
    value = module.vpc_endpoints.endpoints.rds.security_group_rules
}

output "azs" {
    description = "The availability zones in which the RDS instance will be created"
    value = module.vpc.azs
}