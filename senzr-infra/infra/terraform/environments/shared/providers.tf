# terraform/environments/shared/providers.tf

provider "aws" {
  region = "us-east-1"
}

provider "helm" {
  kubernetes {
    host                   = var.k8s_host
    cluster_ca_certificate = var.k8s_cluster_ca_certificate
    token                  = var.k8s_token
  }
}
