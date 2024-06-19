variable "name" {
  description = "The base name for the resources in this module"
  type        = string
  default     = "nextcloud-serverless-tf"
}

variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "eu-south-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}


variable "container_port" {
  description = "The port of the container"
  type        = number
  default     = 80
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "nextcloudserverlessdb"
}

variable "db_username" {
  description = "The username for the RDS instance"
  type        = string
  default     = "lukastheking"
}

variable "db_password" {
  description = "The password for the RDS instance"
  type        = string
  default     = "password123password"
}

variable "nextcloud_admin_user" {
  description = "The admin user for Nextcloud"
  type        = string
  default     = "admin"
}

variable "nextcloud_admin_password" {
  description = "The admin password for Nextcloud"
  type        = string
  default     = "password123password"
}