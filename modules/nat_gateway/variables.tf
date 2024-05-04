variable "subnet_id" {
  description = "The ID of the subnet in which the NAT Gateway should be placed."
  type        = string
}

variable "env" {
  description = "A prefix that is added to the names of the resources for identification purposes."
  type        = string
}

variable "system" {
  description = "The name of the system to which the resources belong."
  type        = string
}