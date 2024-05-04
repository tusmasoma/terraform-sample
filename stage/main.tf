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
