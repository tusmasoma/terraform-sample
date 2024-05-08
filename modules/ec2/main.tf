resource "aws_instance" "ec2" {
  count                   = var.instance_count
  ami                     = var.ami
  instance_type           = var.instance_type
  key_name                = var.key_name
  subnet_id               = element(var.subnets, count.index % length(var.subnets))
  vpc_security_group_ids  = var.security_group_ids
  disable_api_termination = var.disable_api_termination

  tags = {
    Name = "${var.system}-${var.env}-ec2-${count.index + 1}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  count               = var.instance_count
  alarm_name          = "${var.system}-${var.env}-ec2-${count.index + 1}-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "This metric monitors ec2 CPU utilization"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  ok_actions          = [aws_sns_topic.ok.arn]

  dimensions = {
    InstanceId = aws_instance.ec2[count.index].id
  }
}

resource "aws_cloudwatch_metric_alarm" "status_check_alarm" {
  count               = var.instance_count
  alarm_name          = "${var.system}-${var.env}-ec2-${count.index + 1}-status-check-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "This metric monitors ec2 status check"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  ok_actions          = [aws_sns_topic.ok.arn]

  dimensions = {
    InstanceId = aws_instance.ec2[count.index].id
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_alarm" {
  count               = var.instance_count
  alarm_name          = "${var.system}-${var.env}-ec2-${count.index + 1}-disk-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "DiskSpaceUtilization"
  namespace           = "System/Linux"
  period              = 300
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "This metric monitors ec2 disk space utilization"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  ok_actions          = [aws_sns_topic.ok.arn]

  dimensions = {
    InstanceId = aws_instance.ec2[count.index].id
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_alarm" {
  count               = var.instance_count
  alarm_name          = "${var.system}-${var.env}-ec2-${count.index + 1}-memory-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = 300
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "This metric monitors ec2 memory utilization"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  ok_actions          = [aws_sns_topic.ok.arn]

  dimensions = {
    InstanceId = aws_instance.ec2[count.index].id
  }
}

resource "aws_cloudwatch_metric_alarm" "network_alarm" {
  count               = var.instance_count
  alarm_name          = "${var.system}-${var.env}-ec2-${count.index + 1}-network-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 1000000
  alarm_description   = "This metric monitors ec2 network in"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  ok_actions          = [aws_sns_topic.ok.arn]

  dimensions = {
    InstanceId = aws_instance.ec2[count.index].id
  }
}