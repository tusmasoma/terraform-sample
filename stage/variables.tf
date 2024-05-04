variable "cidr_vpc" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "cidr_public" {
    description = "A list of public subnet CIDR blocks"
    type        = list(string)
    default     = []
}

variable "cidr_private" {
    description = "A list of private subnet CIDR blocks"
    type        = list(string)
    default     = []
}

variable "cidr_secure" {
    description = "A list of secure subnet CIDR blocks"
    type        = list(string)
    default     = []
}

variable "name" {
    description = "The name of the VPC"
    type        = string
    default     = ""
}

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

variable "instance_count" {
    description = "The number of instances to deploy"
    type        = number
    default     = 1
}

variable "instance_type" {
    description = "The instance type"
    type        = string
    default     = "t2.micro"
}

variable "ami" {
    description = "The AMI to use for the instance"
    type        = string
    default     = "ami-0c55b159cbfafe1f0"
}

variable "disable_api_termination" {
    description = "If true, enables EC2 Instance Termination Protection"
    type        = bool
    default     = false
}