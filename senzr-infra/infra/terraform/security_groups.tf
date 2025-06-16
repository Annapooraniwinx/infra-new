resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Allow traffic to RDS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
  }
}

resource "aws_security_group" "redis" {
  name        = "redis-sg"
  description = "Allow traffic to Redis"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Redis"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
  }
}