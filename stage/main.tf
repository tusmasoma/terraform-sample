terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

data "aws_acm_certificate" "cert_domain_name" {
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_acm_certificate" "cert_app_domain_name" {
  domain      = "app.${var.domain_name}"
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_acm_certificate" "cert_production_domain_name" {
  domain      = "production.${var.domain_name}"
  statuses    = ["ISSUED"]
  most_recent = true
}

module "network" {
  source       = "../modules/network"
  cidr_vpc     = var.cidr_vpc
  cidr_public  = var.cidr_public
  cidr_private = var.cidr_private
  cidr_secure  = var.cidr_secure
  system       = var.system
  env          = var.env
}

//module "route53" {
//  source       = "../modules/route53"
//  domain_name  = var.domain_name
//  alb_dns_name = module.alb.alb_dns_name
//  alb_zone_id  = module.alb.alb_zone_id
//  cloudfront_app_dns_name = module.cloudfront_app.cloudfront_dns_name
//  cloudfront_production_dns_name = module.cloudfront_production.cloudfront_dns_name
//  cloudfront_app_zone_id  = module.cloudfront_app.cloudfront_zone_id
//  cloudfront_production_zone_id  = module.cloudfront_production.cloudfront_zone_id
//}

module "ec2" {
  source = "../modules/ec2"
  system = var.system
  env    = var.env

  instance_count          = var.ec2
  instance_type           = var.ec2_instance_type
  ami                     = var.ec2_ami
  disable_api_termination = var.ec2_disable_api_termination
  subnets                 = module.network.private_subnet_ids
  security_group_ids      = [module.security_group.ec2_web_to_db_security_group_id]
}

module "alb" {
  source             = "../modules/alb"
  system             = var.system
  env                = var.env
  vpc_id             = module.network.vpc_id
  subnets            = module.network.public_subnet_ids
  instance_ids       = module.ec2.instance_ids
  security_group_ids = [module.security_group.alb_from_443_to_80_security_group_id, module.security_group.alb_from_80_to_443_redirect_security_group_id]
  domain_name        = var.domain_name
  acm_certificate_arn = data.aws_acm_certificate.cert_domain_name.arn
}

module "nat_gateway" {
  source    = "../modules/nat_gateway"
  system    = var.system
  env       = var.env
  subnet_id = module.network.public_subnet_ids[0]
}

module "rds" {
  source                  = "../modules/rds"
  system                  = var.system
  env                     = var.env
  subnets                 = module.network.private_subnet_ids
  engine                  = var.rds_engine
  engine_version          = var.rds_engine_version
  instance_class          = var.rds_instance_class
  db_name                 = var.rds_db_name
  username                = var.rds_username
  password                = var.rds_password
  security_group_ids      = [module.security_group.rds_security_group_id]
  storage_encrypted       = var.rds_storage_encrypted
  skip_final_snapshot     = var.rds_skip_final_snapshot
  backup_retention_period = var.rds_backup_retention_period
  backup_window           = var.rds_backup_window
  parameter_family        = var.rds_parameter_family
  instance_count          = var.rds_instance_count # クラスターインスタンスの数
}

module "s3_app" {
  source      = "../modules/s3"
  bucket_name = "app-${var.s3_bucket_name}"
  cloudfront_origin_access_identity_arn = module.cloudfront_app.cloudfront_oai_iam_arn
}

module "cloudfront_app" {
  source        = "../modules/cloudfront"
  bucket_name   = module.s3_app.bucket_name
  bucket_region = module.s3_app.bucket_region
  aliase        = "app.${var.domain_name}"
  acm_certificate_arn = data.aws_acm_certificate.cert_app_domain_name.arn
}

module "s3_production" {
  source      = "../modules/s3"
  bucket_name = "production-${var.s3_bucket_name}"
  cloudfront_origin_access_identity_arn = module.cloudfront_production.cloudfront_oai_iam_arn
}

module "cloudfront_production" {
  source        = "../modules/cloudfront"
  bucket_name   = module.s3_production.bucket_name
  bucket_region = module.s3_production.bucket_region
  aliase        = "production.${var.domain_name}"
  acm_certificate_arn = data.aws_acm_certificate.cert_production_domain_name.arn
}

module "security_group" {
  source = "../modules/security_group"
  name   = var.name
  env    = var.env
  vpc_id = module.network.vpc_id
}