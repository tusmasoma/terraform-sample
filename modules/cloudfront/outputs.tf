output "cloudfront_oai_iam_arn" {
    value = aws_cloudfront_origin_access_identity.static-www.iam_arn
}

output cloudfront_dns_name {
    value = aws_cloudfront_distribution.static-www.domain_name
}

output cloudfront_zone_id {
    value = aws_cloudfront_distribution.static-www.hosted_zone_id
}