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