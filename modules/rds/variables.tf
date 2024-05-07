variable "env" {
  description = "Environment (e.g., prod, dev, staging)"
}

variable "system" {
  description = "System identifier"
}

variable "subnets" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "engine" {
  description = "Database engine type (e.g., aurora, aurora-mysql, aurora-postgresql)"
}

variable "engine_version" {
  description = "Version of the database engine"
}

variable "db_name" {
  description = "Database name"
}

variable "username" {
  description = "Master username for the database"
}

variable "password" {
  description = "Master password for the database"
}

variable "instance_class" {
  description = "Instance class for the RDS cluster instances"
}

variable "instance_count" {
  description = "Number of instances in the RDS cluster"
  default     = 2
}

variable "parameter_family" {
  description = "Parameter group family"
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
}

variable "backup_window" {
  description = "Preferred backup window"
}

variable "skip_final_snapshot" {
  description = "Whether to skip the creation of a final snapshot on deletion"
  default     = false
}

variable "storage_encrypted" {
  description = "Whether the RDS instance is encrypted"
  default     = false
}