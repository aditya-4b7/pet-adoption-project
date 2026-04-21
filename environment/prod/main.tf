terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source                = "../../modules/vpc"
  project_name          = var.project_name
  env                   = var.env
  vpc_cidr              = var.vpc_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  az_1                  = var.az_1
  az_2                  = var.az_2
}

module "bastion" {
  source            = "../../modules/bastion"
  project_name      = var.project_name
  env               = var.env
  vpc_id            = module.vpc.vpc_id
  public_subnet     = module.vpc.public_subnets[0]
  key_name          = var.key_name
  instance_type     = var.bastion_instance_type
  allowed_ssh_cidr  = var.allowed_admin_cidr
  ami_id            = var.ami_id
  jenkins_security_group_id = module.jenkins.jenkins_sg_id
}

module "jenkins" {
  source         = "../../modules/jenkins"
  project_name   = var.project_name
  env            = var.env
  vpc_id         = module.vpc.vpc_id
  vpc_cidr =  var.vpc_cidr
  public_subnet  = module.vpc.public_subnets[0]
  key_name       = var.key_name
  allowed_cidr   = var.allowed_admin_cidr
  instance_type  = var.jenkins_instance_type
  ami_id         = var.ami_id
  iam_instance_profile_name = var.jenkins_iam_instance_profile_name
}

module "sonarqube" {
  source         = "../../modules/sonarqube"
  project_name   = var.project_name
  env            = var.env
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.public_subnets[0]
  key_name       = var.key_name
  allowed_cidr   = var.allowed_admin_cidr
  instance_type  = var.tool_instance_type
  ami_id         = var.ami_id
  bastion_security_group_id = module.bastion.bastion_sg_id
  jenkins_security_group_id = module.jenkins.jenkins_sg_id
}

module "nexus" {
  source         = "../../modules/nexus"
  project_name   = var.project_name
  env            = var.env
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.public_subnets[1]
  key_name       = var.key_name
  allowed_cidr   = var.allowed_admin_cidr
  instance_type  = var.tool_instance_type
  ami_id         = var.ami_id
  bastion_security_group_id = module.bastion.bastion_sg_id
  jenkins_security_group_id = module.jenkins.jenkins_sg_id
  app_security_group_id = module.asg.app_sg_id 
}

module "acm" {
  source       = "../../modules/acm"
  project_name = var.project_name
  env          = var.env
  domain       = var.domain_name
  zone_id      = var.hosted_zone_id
}

module "alb" {
  source          = "../../modules/alb"
  project_name    = var.project_name
  env             = var.env
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnets
  certificate_arn = module.acm.certificate_arn
}

module "route53" {
  source       = "../../modules/route53"
  zone_id      = var.hosted_zone_id
  project_name = var.project_name
  env          = var.env
  domain_name  = var.domain_name
  alb_dns      = module.alb.alb_dns
  alb_zone_id  = module.alb.alb_zone_id
}

module "asg" {
  source                 = "../../modules/asg"
  project_name           = var.project_name
  env                    = var.env
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.private_subnets
  key_name               = var.key_name
  ami_id                 = var.ami_id
  instance_type          = var.app_instance_type
  desired_capacity       = var.desired_capacity
  min_size               = var.min_size
  max_size               = var.max_size
  target_group_arn       = module.alb.target_group_arn
  alb_security_group     = module.alb.alb_security_group_id
  bastion_security_group = module.bastion.bastion_sg_id
}

output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "bastion_private_ip" {
  value = module.bastion.bastion_private_ip
}

output "jenkins_url" {
  value = module.jenkins.jenkins_url
}

output "sonarqube_url" {
  value = module.sonarqube.sonarqube_url
}

output "nexus_url" {
  value = module.nexus.nexus_url
}
output "nexus_docker_registry" {
  value = module.nexus.nexus_docker_registry
}
output "application_url" {
  value = "https://${var.domain_name}"
}

output "asg_name" {
  value = module.asg.asg_name
}