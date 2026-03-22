provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../../modules/vpc"
}

module "bastion" {
  source        = "../../../modules/bastion"
  vpc_id        = module.vpc.vpc_id
  public_subnet = module.vpc.public_subnets[0]
  key_name      = var.key_name
}

module "alb" {
  source      = "../../modules/alb"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.public_subnets
}

module "acm" {
  source    = "../../modules/acm"
  domain    = var.domain_name
  zone_id   = module.route53.zone_id
}

module "asg" {
  source           = "../../../modules/asg"
  subnet_ids       = module.vpc.private_subnets
  target_group_arn = module.alb.target_group_arn
  key_name         = var.key_name
}

module "route53" {
  source      = "../../modules/route53"
  domain_name = var.domain_name
  alb_dns     = module.alb.alb_dns
  alb_zone_id = module.alb.alb_zone_id
}

module "sonarqube" {
  source    = "../../modules/sonarqube"
  subnet_id = module.vpc.public_subnets[0]
  key_name  = var.key_name
}

module "nexus" {
  source    = "../../modules/nexus"
  subnet_id = module.vpc.public_subnets[0]
  key_name  = var.key_name
}