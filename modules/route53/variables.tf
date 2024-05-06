variable "domain_name" {
  description = "The domain name for creating the Route 53 zone and related records."
  type        = string
  default     = "example.com"
}

variable "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer to be used in A records."
  type        = string
}

variable "alb_zone_id" {
  description = "The Route 53 zone ID for the ALB"
  type        = string
}