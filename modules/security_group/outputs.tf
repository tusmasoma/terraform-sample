output "ec2_security_group_id" {
  value       = aws_security_group.ec2_sg.id
  description = "The ID of the EC2 security group"
}

output "alb_from_443_to_80_security_group_id" {
  value       = aws_security_group.alb_sg_from_443_to_80.id
  description = "The ID of the ALB security group from 443 to 80"
}

output "alb_from_80_to_443_redirect_security_group_id" {
  value       = aws_security_group.alb_sg_from_80_to_443_redirect.id
  description = "The ID of the ALB security group from 80 to 443 redirect"
}

output "rds_security_group_id" {
  value       = aws_security_group.rds_sg.id
  description = "The ID of the RDS security group"
}

output "ec2_web_to_db_security_group_id" {
  value       = aws_security_group.ec2_web_to_db_sg.id
  description = "The ID of the EC2 security group for web to DB"
}