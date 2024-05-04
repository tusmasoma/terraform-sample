output "public_subnets" {
  value = aws_subnet.public
  description = "The public subnets"
}

output "private_subnets" {
  value       = aws_subnet.private
  description = "The private subnets"
}

output "secure_subnets" {
  value       = aws_subnet.secure
  description = "The secure subnets"
}
