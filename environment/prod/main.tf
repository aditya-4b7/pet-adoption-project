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

data "terraform_remote_state" "stage" {
  backend = "s3"

  config = {
    bucket = "pet-adoption-stage-tf-state-083546510470"
    key    = "stage/terraform.tfstate"
    region = "us-east-1"
  }
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
resource "aws_vpc_peering_connection" "stage_prod" {
  vpc_id      = data.terraform_remote_state.stage.outputs.vpc_id
  peer_vpc_id = module.vpc.vpc_id
  auto_accept = true

  tags = {
    Name        = "${var.project_name}-stage-prod-peering"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_route" "stage_public_to_prod" {
  route_table_id            = data.terraform_remote_state.stage.outputs.public_route_table_id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.stage_prod.id
}

resource "aws_route" "stage_private_to_prod" {
  count                     = length(data.terraform_remote_state.stage.outputs.private_route_table_ids)
  route_table_id            = data.terraform_remote_state.stage.outputs.private_route_table_ids[count.index]
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.stage_prod.id
}

resource "aws_route" "prod_public_to_stage" {
  route_table_id            = module.vpc.public_route_table_id
  destination_cidr_block    = data.terraform_remote_state.stage.outputs.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.stage_prod.id
}

resource "aws_route" "prod_private_to_stage" {
  count                     = length(module.vpc.private_route_table_ids)
  route_table_id            = module.vpc.private_route_table_ids[count.index]
  destination_cidr_block    = data.terraform_remote_state.stage.outputs.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.stage_prod.id
}

module "bastion" {
  source           = "../../modules/bastion"
  project_name     = var.project_name
  env              = var.env
  vpc_id           = module.vpc.vpc_id
  public_subnet    = module.vpc.public_subnets[0]
  key_name         = var.key_name
  instance_type    = var.bastion_instance_type
  ami_id           = var.ami_id
   allowed_ssh_cidrs = concat(
    var.allowed_admin_cidrs,
    ["${data.terraform_remote_state.stage.outputs.jenkins_public_ip}/32"]
  )
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

output "application_url" {
  value = "https://${var.domain_name}"
}

output "asg_name" {
  value = module.asg.asg_name
}