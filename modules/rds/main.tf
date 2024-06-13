data "aws_availability_zones" "available" {}

locals {
  azs                          = slice(data.aws_availability_zones.available.names, 0, 3)
  preferred_maintenance_window = "sun:05:00-sun:06:00"

  tags = {
    TestEnv    = "${var.name}-rds"
  }
}

data "aws_rds_engine_version" "postgresql" {
  engine  = "aurora-postgresql"
  version = "14.5"
}

module "aurora_postgresql_v2" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name              = "${var.name}-postgresqlv2"
  engine            = data.aws_rds_engine_version.postgresql.engine
  engine_mode       = "provisioned"
  engine_version    = data.aws_rds_engine_version.postgresql.version
  storage_encrypted = true
  
  master_username   = var.db_username
  manage_master_user_password = false
  master_password   = var.db_password

  vpc_id               = var.vpc_id
  db_subnet_group_name = var.db_subnet_group_name
  security_group_rules = var.security_group_rules

  apply_immediately   = true
  skip_final_snapshot = true

  serverlessv2_scaling_configuration = {
    min_capacity = 1
    max_capacity = 4
  }

  instance_class = "db.serverless"
  instances = {
    one = {}
    two = {}
  }

  tags = local.tags
}