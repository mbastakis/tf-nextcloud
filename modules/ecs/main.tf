locals {

    container_name = "${var.name}-container"
    container_port = 80
    container_image = "public.ecr.aws/docker/library/nextcloud:29.0-apache"

    tags = {
        Name       = "${var.name}-ecs"
        TestEnv    = "${var.name}-ecs"
    }
}

################################################################################
# Cluster
################################################################################

module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"

  cluster_name = "${var.name}-ecs-cluster"
  create_task_exec_iam_role = true

  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
        base   = 20
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  tags = local.tags
}

################################################################################
# Service
################################################################################

module "ecs_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  name        = var.name
  cluster_arn = module.ecs_cluster.arn

  cpu    = 1024
  memory = 4096

  # Enables ECS Exec
  enable_execute_command = true

  # Assign public ip
  assign_public_ip = true

  # Volume
  volume = {
    efs-nextcloud = {
      name = "efs-nextcloud"
      efs_volume_configuration = {
        file_system_id = var.efs_file_system_id
        transit_encryption = "ENABLED"
      }
    }
  }

  # Container definition(s)
  container_definitions = {
    (local.container_name) = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = local.container_image
      port_mappings = [
        {
          name          = local.container_name
          containerPort = local.container_port
          hostPort      = local.container_port
          protocol      = "tcp"
        }
      ]

      # Example image used requires access to write to root filesystem
      readonly_root_filesystem = false

      memory_reservation = 100

      environment = [
        {
          name = "POSTGRES_DB"
          value = var.db_name
        },
        {
          name = "POSTGRES_USER"
          value = var.db_username
        },
        {
          name = "POSTGRES_PASSWORD"
          value = var.db_password
        },
        {
          name = "POSTGRES_HOST"
          value = var.db_host
        },
        {
          name = "NEXTCLOUD_TRUSTED_DOMAINS"
          value = module.alb.dns_name
        },
        {
          name = "NEXTCLOUD_ADMIN_USER"
          value = var.nextcloud_admin_user
        },
        {
          name = "NEXTCLOUD_ADMIN_PASSWORD"
          value = var.nextcloud_admin_password
        },
        {
          name = "NEXTCLOUD_TRUSTED_DOMAINS"
          value = module.alb.dns_name
        },
        {
          name = "OVERWRITEPROTOCOL"
          value = "http"
        }
      ]
      
      mount_points = [
        {
          sourceVolume = "efs-nextcloud"
          containerPath = "/var/www/html"
          readOnly = false
        }
      ]
    }
  }

  load_balancer = {
    service = {
      target_group_arn = module.alb.target_groups["ex_ecs"].arn
      container_name   = local.container_name
      container_port   = local.container_port
    }
  }

  subnet_ids = var.public_subnets
  security_group_rules = {
    alb_ingress_3000 = {
      type                     = "ingress"
      from_port                = local.container_port
      to_port                  = local.container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = module.alb.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  service_tags = {
    "ServiceTag" = "Tag on service level"
  }

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

# resource "aws_service_discovery_http_namespace" "this" {
#   name        = var.name
#   description = "CloudMap namespace for ${var.name}"
#   tags        = local.tags
# }

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name = "${var.name}-alb"

  load_balancer_type = "application"

  vpc_id  = var.vpc_id
  subnets = var.public_subnets

  # For example only
  enable_deletion_protection = false

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = var.vpc_cidr
    }
  }

  listeners = {
    ex_http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "ex_ecs"
      }
    }
  }

  target_groups = {
    ex_ecs = {
      backend_protocol                  = "HTTP"
      backend_port                      = local.container_port
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 120
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }

      # There's nothing to attach here in this definition. Instead,
      # ECS will attach the IPs of the tasks to this target group
      create_attachment = false
    }
  }

  tags = local.tags
}