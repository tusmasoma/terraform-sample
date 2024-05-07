variable "bucket_name" {
  description = "The name of the S3 bucket to be used as the origin for the CloudFront distribution"
  type        = string
}

variable "bucket_region" {
  description = "The AWS region where the S3 bucket is located"
  type        = string
}

variable "aliase" {
  description = "The domain name alias for the CloudFront distribution"
  type        = string
}

variable "acm_certificate_arn" {
  type        = string
  description = "The ARN of the ACM certificate for CloudFront distribution"
}