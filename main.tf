terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  depends_on     = [module.vpc]
}

module "ecs" {
  source                = "./modules/ecs"
  subnets               = module.vpc.private_subnets
  vpc_id                = module.vpc.vpc_id
  alb_security_group_id = module.alb.security_group_id
  target_group_arn      = module.alb.target_group_arn
  depends_on            = [module.alb]
}
