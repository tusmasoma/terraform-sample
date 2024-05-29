resource "aws_cloudfront_distribution" "static-www" {
  origin {
    domain_name              = "${var.bucket_name}.s3.${var.bucket_region}.amazonaws.com"
    origin_id                = var.bucket_name
    origin_access_control_id = aws_cloudfront_origin_access_control.static-www.id
  }

  enabled = true

  aliases = [var.aliase]

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "PUT", "POST", "PATCH", "DELETE", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}

resource "aws_cloudfront_origin_access_identity" "static-www" {
  comment = "OAI for ${var.bucket_name}"
}

resource "aws_cloudfront_origin_access_control" "static-www" {
  name                              = "s3-${var.bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_acm_certificate" "subdomain_cert" {
  domain_name       = var.aliase
  validation_method = "DNS"
}