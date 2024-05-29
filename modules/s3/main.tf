resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  acl           = "private"
  force_destroy = true
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.static-www.json
}

data "aws_iam_policy_document" "static-www" {
  # CloudFront Distribution からのアクセスのみ許可
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [var.cloudfront_distribution_arn]
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_bucket_size" {
  alarm_name          = "${var.bucket_name}-size-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "BucketSizeBytes"
  namespace           = "AWS/S3"
  period              = 300
  statistic           = "Average"
  threshold           = 1000000
  alarm_description   = "This metric monitors S3 bucket size"
  alarm_actions       = []    # TODO: Enable this when you have a valid SNS topic
  ok_actions          = []    # TODO: Enable this when you have a valid SNS topic
  actions_enabled     = false # TODO: Enable this when you have a valid SNS topic

  dimensions = {
    BucketName = var.bucket_name
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_bucket_objects" {
  alarm_name          = "${var.bucket_name}-objects-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "NumberOfObjects"
  namespace           = "AWS/S3"
  period              = 300
  statistic           = "Average"
  threshold           = 1000
  alarm_description   = "This metric monitors S3 bucket objects"
  alarm_actions       = []    # TODO: Enable this when you have a valid SNS topic
  ok_actions          = []    # TODO: Enable this when you have a valid SNS topic
  actions_enabled     = false # TODO: Enable this when you have a valid SNS topic

  dimensions = {
    BucketName = var.bucket_name
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_bucket_requests" {
  alarm_name          = "${var.bucket_name}-requests-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "AllRequests"
  namespace           = "AWS/S3"
  period              = 300
  statistic           = "Sum"
  threshold           = 1000
  alarm_description   = "This metric monitors S3 bucket requests"
  alarm_actions       = []    # TODO: Enable this when you have a valid SNS topic
  ok_actions          = []    # TODO: Enable this when you have a valid SNS topic
  actions_enabled     = false # TODO: Enable this when you have a valid SNS topic

  dimensions = {
    BucketName = var.bucket_name
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_bucket_4xx_errors" {
  alarm_name          = "${var.bucket_name}-4xx-errors-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "4xxError"
  namespace           = "AWS/S3"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "This metric monitors S3 bucket 4xx errors"
  alarm_actions       = []    # TODO: Enable this when you have a valid SNS topic
  ok_actions          = []    # TODO: Enable this when you have a valid SNS topic
  actions_enabled     = false # TODO: Enable this when you have a valid SNS topic

  dimensions = {
    BucketName = var.bucket_name
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_bucket_5xx_errors" {
  alarm_name          = "${var.bucket_name}-5xx-errors-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "5xxError"
  namespace           = "AWS/S3"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "This metric monitors S3 bucket 5xx errors"
  alarm_actions       = []    # TODO: Enable this when you have a valid SNS topic
  ok_actions          = []    # TODO: Enable this when you have a valid SNS topic
  actions_enabled     = false # TODO: Enable this when you have a valid SNS topic

  dimensions = {
    BucketName = var.bucket_name
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_bucket_data_transfer" {
  alarm_name          = "${var.bucket_name}-data-transfer-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "BucketDataTransfer"
  namespace           = "AWS/S3"
  period              = 300
  statistic           = "Sum"
  threshold           = 1000000
  alarm_description   = "This metric monitors S3 bucket data transfer"
  alarm_actions       = []    # TODO: Enable this when you have a valid SNS topic
  ok_actions          = []    # TODO: Enable this when you have a valid SNS topic
  actions_enabled     = false # TODO: Enable this when you have a valid SNS topic

  dimensions = {
    BucketName = var.bucket_name
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_bucket_latency" {
  alarm_name          = "${var.bucket_name}-latency-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "BucketLatency"
  namespace           = "AWS/S3"
  period              = 300
  statistic           = "Average"
  threshold           = 1000
  alarm_description   = "This metric monitors S3 bucket latency"
  alarm_actions       = []    # TODO: Enable this when you have a valid SNS topic
  ok_actions          = []    # TODO: Enable this when you have a valid SNS topic
  actions_enabled     = false # TODO: Enable this when you have a valid SNS topic

  dimensions = {
    BucketName = var.bucket_name
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_bucket_throttle_errors" {
  alarm_name          = "${var.bucket_name}-throttle-errors-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "ThrottleError"
  namespace           = "AWS/S3"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "This metric monitors S3 bucket throttle errors"
  alarm_actions       = []    # TODO: Enable this when you have a valid SNS topic
  ok_actions          = []    # TODO: Enable this when you have a valid SNS topic
  actions_enabled     = false # TODO: Enable this when you have a valid SNS topic

  dimensions = {
    BucketName = var.bucket_name
  }
}
