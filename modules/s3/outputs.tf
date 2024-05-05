output "public_bucket_id" {
  description = "The ID of the public S3 bucket."
  value       = aws_s3_bucket.public_bucket.id
}

output "public_bucket_arn" {
  description = "The ARN of the public S3 bucket."
  value       = aws_s3_bucket.public_bucket.arn
}

output "private_bucket_id" {
  description = "The ID of the private S3 bucket."
  value       = aws_s3_bucket.private_bucket.id
}

output "private_bucket_arn" {
  description = "The ARN of the private S3 bucket."
  value       = aws_s3_bucket.private_bucket.arn
}

output "private_bucket_public_access_block_status" {
  description = "The status of public access block settings for the private S3 bucket."
  value       = aws_s3_bucket_public_access_block.private_bucket_public_access_block.block_public_acls
}
