# ホストゾーン
resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

# レコードセット
resource "aws_route53_record" "a_record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app_a_record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"
  alias {
    name                   = var.cloudfront_app_dns_name
    zone_id                = var.cloudfront_app_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "production_a_record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = "production.${var.domain_name}"
  type    = "A"
  alias {
    name                   = var.cloudfront_production_dns_name
    zone_id                = var.cloudfront_production_zone_id
    evaluate_target_health = true
  }
}

# SSL/TLS証明書
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = ["app.${var.domain_name}", "production.${var.domain_name}"]

  tags = {
    Name = "cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  depends_on = [aws_acm_certificate.cert]

  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}