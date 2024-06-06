# Terraform template to install the Nextcloud application in AWS

This template for Terraform 0.12 installs and configures the latest Nextcloud version along with its dependencies. The configuration uses a MySql RDS instance as database and a S3 bucket as datastore.
  
## Features

* S3 remote backend

### Network

* Custom Virtual Private Cloud (VPC)
* Public and private subnets
* Internet gateway and custom route table

### Nextcloud application

* AWS EC2 instance (t3.micro by default)
* AWS AMI (Ubuntu 18.04 LTS)
* Internet facing (Public subnet)
* Elastic IP associated
* Security group to allow access the Nextcloud UI
* IAM user which only have permissions to connect to the S3 datastore

### Nextcloud database

* RDS for MySql instance (db.t3.micro by default)
* Private subnet
* Security group to allow only access from the Nextcloud app EC2 instance

### Nextcloud datastore

* Data stored in a S3 bucket
* Encryption enabled
* Bucket policy to allow access only to the Nextcloud application IAM user

## How to use

The templates are preconfigured to use S3 as backend and uses partial configuration to decouple the initialization configuration. To configure the backend, fill the `s3_backend_config.hcl` file and run:

```bash
terraform init -backend-config=s3_backend_config.hcl
```

In case you don't want to use the S3 backend, initialize Terraform in the following manner:

```bash
terraform init -backend=false
```

After the initialization, run `terraform plan` to check wich changes will be applied once the generated execution plan is applied:

```bash
terraform plan --out=nextcloud.tfplan
```

Apply the Terraform plan

```bash
terraform apply nextcloud.tfplan
```

Cleanup

```
terraform destroy -auto-approve
```

It takes around **5 minutes** for Nextcloud to be ready to use since Terraform successfully applies the execution plan.

## Configuration

These variables can be changed in the `variables.tf` file.

| Variable | Default value | Description |
|----------|---------------|-------------|
| admin_user |  | Nextcloud admin user |
| admin_pass |  | Nextcloud admin password |
| db_user |  | Nextcloud database root user |
| db_pass |  | Nextcloud database root password
| aws_region | eu-south-1 | Region where to deploy the Nextcloud application and the database |
| nextcloud_instance_type | t3.micro | SSH key name to associate to the Nextcloud app instance |
| nextcloud_key_name | null | SSH key name to associate to the Nextcloud app instance |
| db_instance_type | db.t3.micro | Database instance type |
| vpc_cidr | 10.0.0.0/16 | CIDR of the VPC |
| nextcloud_cidr | 10.0.1.0/24 | CIDR of the public subnet |
| db_cidr | 10.0.2.0/24 | CIDR of the private subnet |
| s3_bucket_name | highly-available-nextcloud-aws-2-loukas | Name of the S3 bucket to use as datastore |
| force_datastore_destroy | false | Destroy all objects so that the bucket can be destroyed without error. These objects are not recoverable |

## Outputs

| Name | Description |
|------|-------------|
| public_ip | Nextcloud application public IP |
| public_dns | Nextcloud application public DNS |

## TODO

* Implement HA using AutoScaling groups + Elastic LoadBalancer
* Install Redis service to implement session storage
* Add ELB health check URL for the Nextcloud application
* Let's Encrypt SSL certificate for the Nextcloud application

## Documentation

### Diagram generation

Generate diagram from terraform: https://hieven.github.io/terraform-visual/

```
 terraform plan -out=plan.out

 terraform show -json plan.out > plan.json
```

### Git conventions

#### Commit Types
- **feat**: Commits that add or remove a new feature
- **fix**: Commits that fix a bug
- **refactor**: Commits that rewrite/restructure code, but do not change any API behavior
- **perf**: Commits that improve performance
- **style**: Commits that do not affect the meaning (white-space, formatting, missing semi-colons, etc.)
- **test**: Commits that add missing tests or correct existing tests
- **docs**: Commits that affect documentation only
- **build**: Commits that affect build components like build tool, CI pipeline, dependencies, project version, etc.
- **ops**: Commits that affect operational components like infrastructure, deployment, backup, recovery, etc.
- **chore**: Miscellaneous commits e.g. modifying .gitignore

#### Commit message
```
<type>(<optional scope>): <short description in present tense>
<optional body>
<optional footer>
```