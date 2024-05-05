variable "system" {
  description = "The system to be deployed"
  type        = string
}

variable "env" {
  description = "The environment to be deployed"
  type        = string
}

variable "subnets" {
  description = "The subnets"
  type        = list(string)
}

variable "security_group_ids" {
  description = "The security group IDs to attach to the instance"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "instance_ids" {
  description = "The instance IDs"
  type        = list(string)
}

variable "cert_arn" {
  description = "The ARN of the SSL/TLS certificate issued for the domain"
  type        = string
}