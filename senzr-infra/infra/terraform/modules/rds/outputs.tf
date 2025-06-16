output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.default.endpoint
}

output "rds_instance_id" {
  description = "The instance ID of the RDS instance"
  value       = aws_db_instance.default.id
}

output "rds_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.default.arn
}
