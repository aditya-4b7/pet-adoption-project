variable "region" { type = string }
variable "project_name" { type = string }
variable "env" { type = string }
variable "key_name" { type = string }
variable "domain_name" { type = string }
variable "allowed_admin_cidr" {
  type = string
}
variable "allowed_admin_cidrs" { type = list(string) }
variable "ami_id" { type = string }
variable "jenkins_instance_type" { type = string }
variable "tool_instance_type" { type = string }
variable "app_instance_type" { type = string }
variable "desired_capacity" { type = number }
variable "min_size" { type = number }
variable "max_size" { type = number }
variable "vpc_cidr" { type = string }
variable "public_subnet_1_cidr" { type = string }
variable "public_subnet_2_cidr" { type = string }
variable "private_subnet_1_cidr" { type = string }
variable "private_subnet_2_cidr" { type = string }
variable "az_1" { type = string }
variable "az_2" { type = string }
variable "bastion_instance_type" { type = string }
variable "hosted_zone_id" { type = string }
variable "jenkins_iam_instance_profile_name" { type = string }