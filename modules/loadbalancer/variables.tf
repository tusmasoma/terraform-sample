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

variable "target_id" {
  description = "The ID of the target instance"
  type        = string
}
