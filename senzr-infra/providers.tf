terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.25"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "postgresql" {
  scheme   = "postgres"
  host     = "directus-postgres.cjguq2ma02dv.ap-south-1.rds.amazonaws.com"
  port     = 5432
  database = "postgres"
  username = "directus_admin"
  password = "DirectsSecure123!"
  sslmode  = "require"
  superuser = false
}
