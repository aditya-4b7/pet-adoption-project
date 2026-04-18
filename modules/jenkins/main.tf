data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

locals {
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ssm_parameter.al2023_ami.value
}

resource "aws_security_group" "jenkins" {
  name   = "${var.project_name}-${var.env}-jenkins-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.env}-jenkins-sg"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_instance" "jenkins" {
  ami                         = local.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins.id]
  iam_instance_profile = var.iam_instance_profile_name


user_data = <<-EOF
              #!/bin/bash
              set -euxo pipefail

              dnf update -y
              dnf install -y git unzip wget tar docker awscli python3 python3-pip java-21-amazon-corretto maven jq

              systemctl enable --now docker
              usermod -aG docker ec2-user

              pip3 install ansible boto3 botocore

              cat > /etc/yum.repos.d/jenkins.repo <<'REPO'
              [jenkins]
              name=Jenkins-stable
              baseurl=https://pkg.jenkins.io/redhat-stable
              gpgcheck=0
              enabled=1
              REPO

              dnf clean all
              dnf install -y jenkins

              usermod -aG docker jenkins

              systemctl enable --now jenkins

              curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin v0.69.3

              cd /tmp
              curl -O https://releases.hashicorp.com/terraform/1.14.8/terraform_1.14.8_linux_amd64.zip
              unzip -o terraform_1.14.8_linux_amd64.zip
              mv terraform /usr/local/bin/terraform
              chmod +x /usr/local/bin/terraform

              systemctl restart docker
              systemctl restart jenkins
              EOF
	
  tags = {
    Name        = "${var.project_name}-${var.env}-jenkins"
    Environment = var.env
    Project     = var.project_name
    Role        = "jenkins"
  }
}
