# terraform/environments/prod/outputs.tf

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "s3_bucket_arn" {
  value = module.s3.bucket_arn
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "kong_url" {
  value = module.kong.kong_url
}

output "directus_url" {
  value = module.directus.directus_url
}
