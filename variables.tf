#############
#  Generic  #
#############

variable "aws_region" {
  description = "Region where to deploy the Nextcloud application and the database"
  type        = string
  default     = "eu-south-1"
}

variable "name" {
  description = "Name of the Nextcloud deployment"
  type        = string
  default     = "nextcloud"
}

###############
#   Network   #
###############

variable "vpc_cidr" {
  description = "CIDR of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones to deploy the Nextcloud application and the database"
  type        = list(string)
  default     = []
}

locals {
  selected_azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

##############
#  Database  #
##############
variable "db_user" {
  description = "Nextcloud database root user"
  type        = string
  default     = "root"
}

variable "db_pass" {
  description = "Nextcloud database root password"
  type        = string
  default     = "12345678abcdef"
}

# #############
# # Instances #
# #############

# variable "aws_region" {
#   description = "Region where to deploy the Nextcloud application and the database"
#   default = "eu-south-1"
# }
# variable "nextcloud_instance_type" {
#     description = "Instance type for the Nextcloud application"
#     default = "t3.micro"
# }

# variable "nextcloud_key_name" {
#     description = "SSH key name to associate to the Nextcloud app instance"
#     default = null
# }

# variable "db_instance_type" {
#   description = "Database instance type"
#   default = "db.t3.micro"
# }


# ###########
# # Network #
# ###########

# variable "vpc_cidr" {
#   description = "CIDR of the VPC"
#   default = "10.0.0.0/16"
# }

# variable "nextcloud_cidr" {
#   description = "CIDR of the public subnet"
#   default = "10.0.1.0/24"
# }

# variable "db_cidr" {
#   description = "CIDR of the private subnet"
#   default = "10.0.2.0/24"
# }


# ############
# # Database #
# ############

# # TODO: add secret management
# # variable "db_user" {
# #   description = "Nextcloud database root user"
# #   default = "root"
# # }

# # variable "db_pass" {
# #   description = "Nextcloud database root password"
# #   default = "12345678abcdef"
# # }

# # variable "db_name" {
# #   description = "Nextcloud database name"
# #   default = "nextcloud-aurora-postgresql"
# # }

# #############
# # Nextcloud #
# #############

# variable "admin_user" {
#   description = "Nextcloud admin user"
#   default = "admin"
# }

# variable "admin_pass" {
#   description = "Nextcloud admin password"
#   default = "12345678abcdef"
# }

# ################
# # S3 datastore #
# ################

# variable "s3_bucket_name" {
#   description = "Name of the S3 bucket to use as datastore"
#   default = "highly-available-nextcloud-aws-datastore01"
# }

# variable "force_datastore_destroy" {
#   description = "Destroy all objects so that the bucket can be destroyed without error. These objects are not recoverable"
#   default = true
# }

# ################
# #  S3 backend  #
# ################
# variable "backend_bucket" {
#   description = "The name of the S3 bucket where the state will be stored"
#   type        = string
#   default     = "highly-available-nextcloud-aws01"
# }

# variable "backend_key" {
#   description = "Key to the state file inside the bucket"
#   type        = string
#   default     = "highly-available-nextcloud-aws01/terraform.tfstate"
# }

# variable "backend_region" {
#   description = "The region of the S3 bucket"
#   type        = string
#   default     = "eu-south-1"
# }