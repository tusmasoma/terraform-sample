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

module "network" {
  source       = "../modules/network"
  cidr_vpc     = var.cidr_vpc
  cidr_public  = var.cidr_public
  cidr_private = var.cidr_private
  cidr_secure  = var.cidr_secure
  system       = var.system
  env          = var.env
}

module "ec2" {
  source = "../modules/ec2"
  system = var.system
  env    = var.env

  instance_count          = var.instance_count
  instance_type           = var.instance_type
  ami                     = var.ami
  disable_api_termination = var.disable_api_termination
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
  allocated_storage       = var.rds_allocated_storage
  storage_type            = var.rds_storage_type
  engine                  = var.rds_engine
  engine_version          = var.rds_engine_version
  instance_class          = var.rds_instance_class
  db_name                 = var.rds_db_name
  username                = var.rds_username
  password                = var.rds_password
  security_group_ids      = [module.security_group.rds_security_group_id]
  multi_az                = var.rds_multi_az
  storage_encrypted       = var.rds_storage_encrypted
  skip_final_snapshot     = var.rds_skip_final_snapshot
  backup_retention_period = var.rds_backup_retention_period
  backup_window           = var.rds_backup_window
  maintenance_window      = var.rds_maintenance_window
  parameter_family        = var.rds_parameter_family
}


module "security_group" {
  source = "../modules/security_group"
  name   = var.name
  env    = var.env
  vpc_id = module.network.vpc_id
}