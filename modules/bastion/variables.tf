variable "project_name" { type = string }
variable "env" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet" { type = string }
variable "key_name" { type = string }
variable "allowed_ssh_cidr" { type = string }
variable "instance_type" { 
    type = string 
}
variable "ami_id" { type = string}
