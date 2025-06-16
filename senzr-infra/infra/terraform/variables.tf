variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}