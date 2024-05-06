output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "The DNS name of the Application Load Balancer"
}

output "alb_zone_id" {
  value       = aws_lb.alb.zone_id
  description = "The Route 53 zone ID for the ALB"
}