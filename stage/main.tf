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
    region = "ap-northeast-1"
}

module "network" {
    source = "../modules/network"
    cidr_vpc = var.cidr_vpc
    cidr_public = var.cidr_public
    cidr_private = var.cidr_private
    cidr_secure = var.cidr_secure
    system = var.system
    env = var.env
}

module "ec2" {
    source = "../modules/ec2"
    system = var.system
    env = var.env

    instance_count = var.instance_count
    instance_type = var.instance_type
    ami = var.ami
    disable_api_termination = var.disable_api_termination
    subnets = module.network.private_subnet_ids
    security_group_ids = [module.security_group.ec2_web_to_db_security_group_id]
}

module "alb" {
    source = "../modules/alb"
    system = var.system
    env = var.env
    vpc_id = module.network.vpc_id
    subnets = module.network.public_subnet_ids
    instance_ids = module.ec2.instance_ids
    security_group_ids = [module.security_group.alb_security_group_id]
}

module "security_group" {
    source = "../modules/security_group"
    name = var.name
    env = var.env
    vpc_id = module.network.vpc_id
}