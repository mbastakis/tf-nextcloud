variable "s3_bucket_name" {
    description = "Name of the S3 bucket to use as datastore"
}

variable "nextcloud_iam_user_arn" {
    description = "ARN of the IAM user used by the Nextcloud app"
}
variable "devops_root_account_arn" {
    description = "ARN of the IAM user used by the Nextcloud app"
    default = "9054-1832-5152"
}

variable "terraform_iam_user_arn" {
    description = "ARN of the IAM user used by Terraform"
}

variable "force_destroy" {
    description = "Destroy all the objects in this bucket so that the bucket can be destroyed without error"
    default = true
}