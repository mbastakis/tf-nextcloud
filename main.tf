
module "vpc" {
    source = "./modules/vpc"
    name = var.name

    region = var.region
    vpc_cidr = var.vpc_cidr
}

module "rds" {
    source = "./modules/rds"
    name = var.name

    region = var.region
    vpc_cidr = var.vpc_cidr
    available_zones = module.vpc.azs
    db_username = var.db_username
    db_password = var.db_password
    vpc_id = module.vpc.vpc_id
    db_subnet_group_name = module.vpc.database_subnet_group_name
    security_group_rules = module.vpc.db_security_group_rules
}