output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "The public subnets"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "The private subnets"
}

output "secure_subnet_ids" {
  value       = aws_subnet.secure[*].id
  description = "The secure subnets"
}
