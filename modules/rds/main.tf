resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.env}-${var.system}-db-subnet-group"
  description = "Database subnet group for ${var.env}-${var.system}"
  subnet_ids  = var.subnets

  tags = {
    "Name" = "${var.env}-${var.system}-db-subnet-group"
    "Environment" = var.env
  }
}

resource "aws_db_instance" "rds" {
  identifier = "${var.env}-${var.system}-rds"
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.rds_name
  username             = var.rds_username
  password             = var.rds_password
  parameter_group_name = aws_db_parameter_group.rds_param_group.name
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = var.security_group_ids
  multi_az             = var.multi_az
  storage_encrypted    = var.storage_encrypted
  skip_final_snapshot  = var.skip_final_snapshot

  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window

  tags = {
    "Name" = "${var.env}-${var.system}-rds"
    "Environment" = var.env
  }
}

resource "aws_db_parameter_group" "rds_param_group" {
  name   = "${var.env}-${var.system}-db-param-group"
  family = var.rds_parameter_family

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  tags = {
    "Name" = "${var.env}-${var.system}-db-param-group"
    "Environment" = var.env
  }
}
