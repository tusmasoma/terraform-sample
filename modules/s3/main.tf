# public s3 bucket
resource "aws_s3_bucket" "public_bucket" {
  bucket        = var.public_bucket_name
  region        = var.region
  acl           = "public-read"
  force_destroy = true
  versioning {
    enabled    = true
    mfa_delete = false
  }
  tags = {
    Name = var.public_bucket_name
  }
}

resource "aws_s3_bucket_policy" "public_bucket_policy" {
  bucket = aws_s3_bucket.public_bucket.bucket
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.public_bucket.arn}/*"
      }
    ]
  })
}

# private s3 bucket
resource "aws_s3_bucket" "private_bucket" {
  bucket        = var.private_bucket_name
  region        = var.region
  acl           = "private"
  force_destroy = true
  versioning {
    enabled    = true
    mfa_delete = false
  }
  tags = {
    Name = var.private_bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "private_bucket_public_access_block" {
  bucket = aws_s3_bucket.private_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}