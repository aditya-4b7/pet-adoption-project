data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

locals {
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ssm_parameter.al2023_ami.value
}

resource "aws_security_group" "sonarqube" {
  name = "${var.project_name}-${var.env}-sonarqube-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [var.bastion_security_group_id]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.env}-sonarqube-sg"
    Environment = var.env
    Project     = var.project_name
  }
}
resource "aws_instance" "sonarqube" {
  ami = local.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  key_name = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.sonarqube.id]
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker
              systemctl enable --now docker
              docker run -d --name sonarqube --restart always -p 9000:9000 sonarqube:lts-community
              EOF
  tags = { 
    Name = "${var.project_name}-${var.env}-sonarqube" 
    Environment = var.env 
    Project = var.project_name 
    Role = "sonarqube" 
    }
}
