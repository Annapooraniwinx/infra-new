# terraform/environments/prod/main.tf

module "vpc" {
  source     = "../../modules/vpc"
  vpc_cidr   = var.vpc_cidr
  name       = "prod-vpc"
}

module "eks" {
  source        = "../../modules/eks"
  cluster_name  = "prod-cluster"
  cluster_version = "1.21"
  subnet_ids    = var.subnet_ids
  vpc_id        = module.vpc.vpc_id
}

module "s3" {
  source     = "../../modules/s3"
  bucket_name = "prod-s3-bucket"
  tags        = var.s3_tags
}

module "rds" {
  source     = "../../modules/rds"
  db_name    = "prod-db"
  db_user    = var.db_user
  db_password = var.db_password
  instance_type = "db.m5.large"
}

module "kong" {
  source          = "../../modules/kong"
  kong_namespace  = var.kong_namespace
}

module "directus" {
  source          = "../../modules/directus"
  directus_namespace = var.directus_namespace
}
