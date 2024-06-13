
module "vpc" {
    source = "./modules/vpc"
    name = var.name

    region = var.region
    vpc_cidr = var.vpc_cidr
}