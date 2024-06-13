
data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}-vpc"
  cidr = var.vpc_cidr

  azs = local.azs
  private_subnets     = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  public_subnets      = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]
  database_subnets    = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 8)]
  # elasticache_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 12)]
  # redshift_subnets    = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 16)]
  # intra_subnets       = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 20)]

  # private_subnet_names = ["Private Subnet One", "Private Subnet Two"]
  # public_subnet_names omitted to show default name generation for all three subnets
  # database_subnet_names    = ["DB Subnet One"]
  # elasticache_subnet_names = ["Elasticache Subnet One", "Elasticache Subnet Two"]
  # redshift_subnet_names    = ["Redshift Subnet One", "Redshift Subnet Two", "Redshift Subnet Three"]
  # intra_subnet_names       = []

  create_database_subnet_group  = true
  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_vpn_gateway = true

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
}

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id = module.vpc.vpc_id

  create_security_group      = true
  security_group_name_prefix = "${var.name}-vpc-endpoints-"
  security_group_description = "VPC endpoint security group"
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [module.vpc.vpc_cidr_block]
    }
  }

  endpoints = {
    # s3 = {
    #   service             = "s3"
    #   private_dns_enabled = true
    #   dns_options = {
    #     private_dns_only_for_inbound_resolver_endpoint = false
    #   }
    #   tags = { Name = "s3-vpc-endpoint" }
    # },
    # dynamodb = {
    #   service         = "dynamodb"
    #   service_type    = "Gateway"
    #   route_table_ids = flatten([module.vpc.intra_route_table_ids, module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
    #   policy          = data.aws_iam_policy_document.dynamodb_endpoint_policy.json
    #   tags            = { Name = "dynamodb-vpc-endpoint" }
    # },
    # ecs = {
    #   service             = "ecs"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    # },
    # ecs_telemetry = {
    #   create              = false
    #   service             = "ecs-telemetry"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    # },
    # ecr_api = {
    #   service             = "ecr.api"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    #   policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
    # },
    # ecr_dkr = {
    #   service             = "ecr.dkr"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    #   policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
    # },
    rds = {
      service             = "rds"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      security_group_ids  = [module.vpc_endpoints.security_group_id]
    },
  }
}

module "database" {
  source  = "terraform-aws-modules/rds-aurora/aws"

  name              = "${var.name}-aurora-postgresql"
  engine            = "aurora-postgresql"
  engine_mode       = "serverless"
  storage_encrypted = true
  

  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.database_subnet_group_name
  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  }

  manage_master_user_password = false
  master_username             = var.db_user
  master_password             = var.db_pass

  monitoring_interval = 60

  skip_final_snapshot          = true
  apply_immediately            = true

  scaling_configuration = {
    auto_pause               = true
    min_capacity             = 1
    max_capacity             = 4
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}