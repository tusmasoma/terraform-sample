output "aurora_cluster_id" {
  value       = aws_rds_cluster.aurora_cluster.id
  description = "The ID of the RDS Aurora cluster"
}

output "aurora_cluster_endpoint" {
  value       = aws_rds_cluster.aurora_cluster.endpoint
  description = "The endpoint of the RDS Aurora cluster"
}

output "aurora_instance_endpoints" {
  value       = [for instance in aws_rds_cluster_instance.aurora_instances : instance.endpoint]
  description = "The endpoints of the Aurora cluster instances"
}
