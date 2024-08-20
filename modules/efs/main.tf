locals {

    name = "${var.name}-efs"

    tags = {
        Name       = "${var.name}-efs"
        TestEnv    = "${var.name}-efs"
    }
}

data "aws_availability_zones" "available" {}

module "efs" {
  source = "terraform-aws-modules/efs/aws"

  name           = local.name
  creation_token = local.name
  encrypted      = true

  lifecycle_policy = {
    transition_to_ia                    = "AFTER_30_DAYS"
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }

  mount_targets = { for k, v in zipmap(var.available_zones, var.public_subnets) : k => { subnet_id = v } }

  security_group_description = "EFS security group"
  security_group_vpc_id      = var.vpc_id
  security_group_rules = {
    vpc = {
      # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC private subnets"
      cidr_blocks = var.public_subnets_cidr_blocks
    }
  }

  tags = local.tags
}