data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

locals {
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ssm_parameter.al2023_ami.value
}

resource "aws_security_group" "bastion" {
  name = "${var.project_name}-${var.env}-bastion-sg"
  vpc_id = var.vpc_id
  ingress { 
    from_port = 22 
    to_port = 22 
    protocol = "tcp" 
    cidr_blocks = [var.allowed_ssh_cidr] 
  }

  ingress {
    from_port = 22 
    to_port = 22 
    protocol = "tcp"
    security_groups = [var.jenkins_security_group_id]
  }
  egress { 
    from_port = 0 
    to_port = 0 
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
    
  }

    tags = { 

      Name = "${var.project_name}-${var.env}-bastion-sg" 
      Environment = var.env 
      Project = var.project_name
       }

}
resource "aws_instance" "bastion" {
  ami = local.ami_id
  instance_type = var.instance_type
  subnet_id = var.public_subnet
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y git unzip python3 python3-pip
              EOF
  tags = { 
    Name = "${var.project_name}-${var.env}-bastion" 
    Environment = var.env 
    Project = var.project_name 
    Role = "bastion" 
  }
}
