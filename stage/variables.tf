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

variable "domain_name" {
  description = "The domain name for creating the Route 53 zone and related records."
  type        = string
  default     = "example.com"
}

variable "ec2_instance_count" {
  description = "The number of instances to deploy"
  type        = number
  default     = 1
}

variable "ec2_instance_type" {
  description = "The instance type"
  type        = string
  default     = "t2.micro"
}

variable "ec2_ami" {
  description = "The AMI to use for the instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "ec2_disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  type        = bool
  default     = false
}

variable "rds_engine" {
  description = "The database engine to use for the RDS instance (e.g., mysql, postgresql)"
}

variable "rds_engine_version" {
  description = "The version of the database engine for the RDS instance"
}

variable "rds_instance_class" {
  description = "The instance type of the RDS instance (e.g., db.m4.large)"
}

variable "rds_db_name" {
  description = "The name of the database to create within the RDS instance"
}

variable "rds_username" {
  description = "Username for the RDS database administrator"
}

variable "rds_password" {
  description = "Password for the RDS database administrator"
}

variable "rds_storage_encrypted" {
  description = "Specifies whether the RDS instance is encrypted"
  default     = false
}

variable "rds_skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the RDS instance is deleted"
  default     = true
}

variable "rds_backup_retention_period" {
  description = "The number of days to retain backups for the RDS instance"
  default     = 7
}

variable "rds_backup_window" {
  description = "The daily time range during which automated backups are created for the RDS instance"
}

variable "rds_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur on the RDS instance"
}

variable "rds_parameter_family" {
  description = "The family of the DB parameter group for the RDS instance"
}

variable "rds_instance_count" {
  description = "Number of instances in the RDS cluster"
  type        = number
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}
