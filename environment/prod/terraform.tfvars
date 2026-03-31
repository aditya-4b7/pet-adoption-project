# region                = "us-east-1"
# project_name          = "pet-adoption"
# env                   = "prod"
# key_name              = "pet-adoption-key"
# domain_name           = "cloud4u.shop"
# allowed_admin_cidr    = "185.156.47.6/32"
# jenkins_instance_type = "t3.micro"
# tool_instance_type    = "t3.micro"
# app_instance_type     = "t3.micro"
# desired_capacity      = 1
# min_size              = 1
# max_size              = 2
# vpc_cidr              = "10.20.0.0/16"
# public_subnet_1_cidr  = "10.20.1.0/24"
# public_subnet_2_cidr  = "10.20.2.0/24"
# private_subnet_1_cidr = "10.20.11.0/24"
# private_subnet_2_cidr = "10.20.12.0/24"
# az_1                  = "us-east-1a"
# az_2                  = "us-east-1b"
# bastion_instance_type = "t3.micro"
# ami_id = "ami-02dfbd4ff395f2a1b"
# hosted_zone_id = "Z007485728RD8IL8CSEN0"

region                = "us-east-1"
project_name          = "pet-adoption"
env                   = "prod"
key_name              = "pet-adoption-key"
domain_name           = "cloud4u.shop"
hosted_zone_id        = "Z007485728RD8IL8CSEN0"
allowed_admin_cidr    = "185.156.47.12/32"

bastion_instance_type = "t3.micro"
jenkins_instance_type = "t3.micro"
tool_instance_type    = "t3.micro"
app_instance_type     = "t3.micro"

desired_capacity      = 1
min_size              = 1
max_size              = 1

vpc_cidr              = "10.20.0.0/16"
public_subnet_1_cidr  = "10.20.1.0/24"
public_subnet_2_cidr  = "10.20.2.0/24"
private_subnet_1_cidr = "10.20.11.0/24"
private_subnet_2_cidr = "10.20.12.0/24"

az_1                  = "us-east-1a"
az_2                  = "us-east-1b"

ami_id                = "ami-02dfbd4ff395f2a1b"