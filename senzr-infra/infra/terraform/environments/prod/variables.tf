# terraform/environments/prod/variables.tf

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs"
}

variable "s3_tags" {
  type        = map(string)
  description = "Tags to apply to the S3 bucket"
}

variable "rds_instance_type" {
  type        = string
  description = "Instance type for RDS"
}

variable "rds_db_name" {
  type        = string
  description = "Database name for RDS"
}

variable "rds_db_user" {
  type        = string
  description = "Database user for RDS"
}

variable "rds_db_password" {
  type        = string
  description = "Database password for RDS"
  sensitive   = true
}

variable "sg_ids" {
  type        = list(string)
  description = "List of security group IDs"
}

variable "subnet_group" {
  type        = string
  description = "Subnet group for RDS"
}
