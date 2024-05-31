variable "instance_type" {
    default = "t3.micro"
}

variable "aws_region"{
    default = "eu-south-1"
}

variable "subnet_id" {
    description = "Subnet to place this instance"
}

variable "vpc_id" {
    description = "Vpc id to assign to this instance"
}

variable "key_name" {
    description = "SSH Key name to associate to this instance"
}