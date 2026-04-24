variable "project_name" { type = string }
variable "env" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet" { type = string }
variable "key_name" { type = string }
variable "allowed_ssh_cidrs" { type = list(string) }
variable "instance_type" { 
    type = string 
}
variable "ami_id" { type = string}
variable "jenkins_security_group_id" { 
    type = string 
    default = ""
    }