resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.env}-${var.system}-db-subnet-group"
  description = "Database subnet group for ${var.env}-${var.system}"
  subnet_ids  = var.subnets

  tags = {
    "Name"        = "${var.env}-${var.system}-db-subnet-group"
    "Environment" = var.env
  }
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier   = "${var.env}-${var.system}-aurora-cluster"
  engine               = var.engine
  engine_version       = var.engine_version
  database_name        = var.db_name
  master_username      = var.username
  master_password      = var.password
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  vpc_security_group_ids          = var.security_group_ids
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_param_group.name

  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.backup_window
  skip_final_snapshot     = var.skip_final_snapshot
  storage_encrypted       = var.storage_encrypted

  tags = {
    "Name"        = "${var.env}-${var.system}-aurora-cluster"
    "Environment" = var.env
  }
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count                = var.instance_count
  identifier           = "${var.env}-${var.system}-aurora-instance-${count.index}"
  cluster_identifier   = aws_rds_cluster.aurora_cluster.id
  instance_class       = var.instance_class
  engine               = var.engine
  engine_version       = var.engine_version
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    "Name"        = "${var.env}-${var.system}-aurora-instance-${count.index}"
    "Environment" = var.env
  }
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_param_group" {
  name   = "${var.env}-${var.system}-aurora-cluster-param-group"
  family = var.parameter_family

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  tags = {
    "Name"        = "${var.env}-${var.system}-aurora-cluster-param-group"
    "Environment" = var.env
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  count               = var.instance_count
  alarm_name          = "${var.env}-${var.system}-aurora-instance-${count.index}-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "This metric monitors RDS CPU utilization"
  alarm_actions       = []    # TODO: Enable this when you have a valid SNS topic
  ok_actions          = []    # TODO: Enable this when you have a valid SNS topic
  actions_enabled     = false # TODO: Enable this when you have a valid SNS topic

  dimensions = {
    DBInstanceIdentifier = aws_rds_cluster_instance.aurora_instances[count.index].id
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_high_connection_count" {
  count               = var.instance_count
  alarm_name          = "${var.env}-${var.system}-aurora-instance-${count.index}-connection-count-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 100
  alarm_description   = "This metric monitors RDS connection count"
  alarm_actions       = []    # TODO: Enable this when you have a valid SNS topic
  ok_actions          = []    # TODO: Enable this when you have a valid SNS topic
  actions_enabled     = false # TODO: Enable this when you have a valid SNS topic

  dimensions = {
    DBInstanceIdentifier = aws_rds_cluster_instance.aurora_instances[count.index].id
  }
}