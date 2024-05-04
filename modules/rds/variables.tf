variable "env" {
  description = "The environment (e.g., prod, dev, staging)"
}

variable "system" {
  description = "System identifier"
}

variable "subnets" {
  description = "List of subnet IDs for the DB Subnet Group"
  type        = list(string)
}

variable "allocated_storage" {
  description = "The allocated storage size for the RDS instance (in gigabytes)"
}

variable "storage_type" {
  description = "The type of storage (e.g., gp2, io1)"
}

variable "engine" {
  description = "The database engine to use (e.g., mysql, postgresql)"
}

variable "engine_version" {
  description = "The version of the database engine"
}

variable "instance_class" {
  description = "The instance type of the RDS instance (e.g., db.m4.large)"
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created"
}

variable "username" {
  description = "Username for the database administrator"
}

variable "password" {
  description = "Password for the database administrator"
}

variable "security_group_ids" {
  description = "List of VPC security group IDs to associate"
  type        = list(string)
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  default     = false
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  default     = false
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  default     = true
}

variable "backup_retention_period" {
  description = "The number of days to retain backups for"
  default     = 7
}

variable "backup_window" {
  description = "The daily time range during which automated backups are created"
}

variable "maintenance_window" {
  description = "The weekly time range during which system maintenance can occur"
}

variable "parameter_family" {
  description = "The family of the DB parameter group"
}
