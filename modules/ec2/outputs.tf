output "instance_id" {
  value       = aws_instance.ec2.*.id
  description = "List of IDs of the EC2 instances"
}

output "public_ip" {
  value       = aws_instance.ec2.*.public_ip
  description = "List of public IP addresses of the EC2 instances"
}

output "private_ip" {
  value       = aws_instance.ec2.*.private_ip
  description = "List of private IP addresses of the EC2 instances"
}
