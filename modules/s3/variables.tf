variable "public_bucket_name" {
  description = "The name of the public S3 bucket."
  type        = string
}

variable "private_bucket_name" {
  description = "The name of the private S3 bucket."
  type        = string
}

variable "region" {
  description = "The AWS region where the buckets will be created."
  type        = string
  default     = "ap-northeast-1"
}
