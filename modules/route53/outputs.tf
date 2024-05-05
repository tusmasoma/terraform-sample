output "route53_zone_id" {
  value       = aws_route53_zone.hosted_zone.zone_id
  description = "The ID of the Route 53 hosted zone created for the domain."
}

output "acm_certificate_arn" {
  value       = aws_acm_certificate.cert.arn
  description = "The ARN of the SSL/TLS certificate issued for the domain."
}
