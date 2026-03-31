data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

locals {
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ssm_parameter.al2023_ami.value
}

resource "aws_security_group" "jenkins" {
  name = "${var.project_name}-${var.env}-jenkins-sg"
  vpc_id = var.vpc_id
  ingress { 
    from_port = 22 
    to_port = 22 
    protocol = "tcp" 
    cidr_blocks = [var.allowed_cidr] 
    }
  ingress { 
    from_port = 8080 
    to_port = 8080 
    protocol = "tcp" 
    cidr_blocks = [var.allowed_cidr] 
    }
  egress { 
    from_port = 0 
    to_port = 0 
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
    }
  tags = { 
    Name = "${var.project_name}-${var.env}-jenkins-sg" 
    Environment = var.env 
    Project = var.project_name 
    }
}
resource "aws_instance" "jenkins" {
  ami = local.ami_id
  instance_type = var.instance_type
  subnet_id = var.public_subnet
  key_name = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y git unzip wget curl tar docker awscli python3 python3-pip java-17-amazon-corretto
              systemctl enable --now docker
              usermod -aG docker ec2-user
              curl -fsSL https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key | tee /etc/pki/rpm-gpg/jenkins.io.key > /dev/null
              cat > /etc/yum.repos.d/jenkins.repo <<'REPO'
              [jenkins]
              name=Jenkins-stable
              baseurl=https://pkg.jenkins.io/redhat-stable
              gpgcheck=1
              enabled=1
              REPO
              rpm --import /etc/pki/rpm-gpg/jenkins.io.key
              dnf install -y jenkins
              systemctl enable --now jenkins
              pip3 install ansible boto3 botocore
              EOF
  tags = { Name = "${var.project_name}-${var.env}-jenkins" 
  Environment = var.env 
  Project = var.project_name 
  Role = "jenkins" }
}
