variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "cloudfront_origin_access_identity_arn" {
  description = "The ARN of the CloudFront origin access identity."
  type        = string
}