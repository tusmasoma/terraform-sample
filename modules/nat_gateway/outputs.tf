output "nat_gateway_id" {
  value       = aws_nat_gateway.nat.id
  description = "The ID of the NAT Gateway."
}

output "nat_gateway_public_ip" {
  value       = aws_eip.nat.public_ip
  description = "The public IP address of the NAT Gateway."
}
