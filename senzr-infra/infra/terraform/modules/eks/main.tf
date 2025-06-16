provider "aws" {
  region = "us-west-2"  # Modify to your desired AWS region
}

# Define the VPC module (or you can create VPC resources directly)
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = "dev-vpc"
  cidr = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Define the EKS module
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "dev-cluster"
  cluster_version = "1.21"
  subnet_ids      = var.subnet_ids  # Assuming subnet_ids are provided in the variables
  vpc_id          = module.vpc.vpc_id
}

# Example Security Group for EKS (Optional, adjust per your setup)
resource "aws_security_group" "eks" {
  name_prefix = "eks-sg-"
  vpc_id      = module.vpc.vpc_id
}
