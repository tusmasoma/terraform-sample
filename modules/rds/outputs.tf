output "rds_instance_endpoint" {
  value       = aws_db_instance.rds.endpoint
  description = "The connection endpoint for the database instance."
}

output "rds_instance_arn" {
  value       = aws_db_instance.rds.arn
  description = "The ARN of the database instance."
}
