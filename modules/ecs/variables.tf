variable name {
    description = "The name of the ECS service"
    type        = string
}

variable container_port {
    description = "The port of the container"
    type        = number
}

variable region {
    description = "The AWS region"
    type        = string
}

variable public_subnets {
    description = "The public subnet IDs"
    type        = list(string)
}

variable vpc_id {
    description = "The VPC ID"
    type        = string
}

variable vpc_cidr {
    description = "The VPC CIDR"
    type        = string
}

variable db_name {
    description = "The name of the database"
    type        = string
}

variable db_username {
    description = "The username for the database"
    type        = string
}

variable db_password {
    description = "The password for the database"
    type        = string
}

variable db_host {
    description = "The host of the database"
    type        = string
}

variable nextcloud_admin_user {
    description = "The admin user for Nextcloud"
    type        = string
}

variable nextcloud_admin_password {
    description = "The admin password for Nextcloud"
    type        = string
}

variable "efs_file_system_id" {
    description = "The ID of the EFS file system"
    type        = string
}