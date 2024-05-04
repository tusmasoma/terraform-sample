variable "system" {
    description = "The system to be deployed"
    type        = string
    default     = ""
}

variable "env" {
    description = "The environment to be deployed"
    type        = string
    default     = ""
}

variable "vpc_id" {
    description = "The VPC ID"
    type        = string
    default     = ""
}

variable "subnets" {
    description = "The subnets"
    type        = list(string)
    default     = []
}

variable "ami" {
    description = "The AMI to use for the instance"
    type        = string
    default     = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
    description = "The instance type to use for the instance"
    type        = string
    default     = "t2.micro"
}

variable "key_name" {
    description = "The key name to use for the instance"
    type        = string
    default     = ""
}

variable "instance_count" {
    description = "The number of instances to deploy"
    type        = number
    default     = 1
}

variable "disable_api_termination" {
    description = "If true, enables EC2 Instance Termination Protection"
    type        = bool
    default     = false
}

variable "security_group_ids" {
    description = "The security group IDs to attach to the instance"
    type        = list(string)
    default     = []
}