# terraform/environments/prod/terraform.tfvars

vpc_cidr  = "10.1.0.0/16"
subnet_ids = ["subnet-prod1", "subnet-prod2"]
s3_tags    = {
  Environment = "prod"
  Team        = "prodops"
}
rds_instance_type = "db.m5.large"
rds_db_name       = "prod-db"
rds_db_user       = "admin"
rds_db_password   = "prod-password"
sg_ids            = ["sg-prod1", "sg-prod2"]
subnet_group      = "prod-subnet-group"
