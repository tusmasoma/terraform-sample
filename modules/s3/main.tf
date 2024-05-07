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
  statement {
    sid    = "Allow CloudFront"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [var.cloudfront_origin_access_identity_arn]
    }
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*"
    ]
  }
}