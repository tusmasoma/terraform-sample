output "cloudfront_oai_iam_arn" {
    value = aws_cloudfront_origin_access_identity.static-www.iam_arn
}