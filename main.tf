
module "vpc" {
  source = "./modules/vpc"
  name   = var.name

  region   = var.region
  vpc_cidr = var.vpc_cidr
}

module "rds" {
  source  = "./modules/rds"
  name    = var.name
  db_name = var.db_name

  region                 = var.region
  vpc_cidr               = var.vpc_cidr
  available_zones        = module.vpc.azs
  db_username            = var.db_username
  db_password            = var.db_password
  vpc_id                 = module.vpc.vpc_id
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = module.vpc.db_security_group_ids
}

module "ecs" {
  source = "./modules/ecs"

  name           = var.name
  container_port = var.container_port
  region         = var.region
  public_subnets = module.vpc.public_subnets
  vpc_id         = module.vpc.vpc_id
  vpc_cidr       = var.vpc_cidr

  db_name                  = module.rds.db_name
  db_username              = var.db_username
  db_password              = var.db_password
  db_host                  = module.rds.db_host
  nextcloud_admin_user     = var.nextcloud_admin_user
  nextcloud_admin_password = var.nextcloud_admin_password
}