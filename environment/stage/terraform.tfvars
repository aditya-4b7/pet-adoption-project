region                = "us-east-1"
project_name          = "pet-adoption"
env                   = "stage"
key_name              = "pet-adoption-key"
domain_name           = "stage.cloud4u.shop"
hosted_zone_id        = "Z007485728RD8IL8CSEN0"

allowed_admin_cidr    = "142.126.95.86/32"
# allowed_admin_cidr    = "217.79.118.167/32"

bastion_instance_type = "t3.micro"
jenkins_instance_type = "m7i-flex.large"
tool_instance_type    = "m7i-flex.large"
app_instance_type     = "t3.micro"

desired_capacity      = 1
min_size              = 1
max_size              = 1

vpc_cidr              = "10.10.0.0/16"
public_subnet_1_cidr  = "10.10.1.0/24"
public_subnet_2_cidr  = "10.10.2.0/24"
private_subnet_1_cidr = "10.10.11.0/24"
private_subnet_2_cidr = "10.10.12.0/24"

az_1                  = "us-east-1a"
az_2                  = "us-east-1b"

ami_id                = "ami-02dfbd4ff395f2a1b"
jenkins_iam_instance_profile_name = "instanceRole_for_Jenkins"