provider "aws" {
  region = "us-west-2"  # Modify to your desired AWS region
}

# Define the VPC module (if you're not using an existing one)
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "rds-vpc"
  cidr   = "10.0.0.0/16"
}

# Define the Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group for RDS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5432  # Default PostgreSQL port
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the RDS instance
resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"  # You can change this to MySQL or another database
  engine_version       = "13.3"  # Specify your required version
  instance_class       = "db.t3.micro"
  name                 = "mydatabase"  # Change this to your database name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az             = false
  publicly_accessible  = true

  tags = {
    Name = "RDS-Instance"
  }

  final_snapshot_identifier = "final-snapshot"
}

# Create a subnet group for RDS
resource "aws_db_subnet_group" "default" {
  name        = "rds-subnet-group"
  subnet_ids  = module.vpc.private_subnets
  description = "Subnet group for RDS instances"
}

