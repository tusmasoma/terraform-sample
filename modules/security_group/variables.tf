variable "name" {
  description = "The name of the security group"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

variable "env" {
  description = "The environment (e.g., prod, dev) for the security group"
  type        = string
}