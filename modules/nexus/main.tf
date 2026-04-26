data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

locals {
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ssm_parameter.al2023_ami.value
}

resource "aws_security_group" "nexus" {
  name = "${var.project_name}-${var.env}-nexus-sg"
  vpc_id = var.vpc_id
  ingress { 
    from_port = 22 
    to_port = 22 
    protocol = "tcp" 
    security_groups = [var.bastion_security_group_id]
    }
      
    ingress { 
      from_port = 8081 
      to_port = 8081 
      protocol = "tcp" 
      cidr_blocks = [var.allowed_cidr] 
      }

      ingress {
        from_port = 8081
        to_port = 8081
        protocol = "tcp"
        security_groups = [var.jenkins_security_group_id]
      }
          ingress {
        from_port = 8082
        to_port = 8082
        protocol = "tcp"
        security_groups = [var.jenkins_security_group_id]
      }

       ingress {
        from_port = 8082
        to_port = 8082
        protocol = "tcp"
        security_groups = [var.app_security_group_id]
      }
      
        ingress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
  }
    egress { 
      from_port = 0 
      to_port = 0 
        protocol = "-1" 
        cidr_blocks = ["0.0.0.0/0"] 
        }
    tags = { 
      Name = "${var.project_name}-${var.env}-nexus-sg" 
      Environment = var.env 
      Project = var.project_name 
      }
  }
resource "aws_instance" "nexus" {
  ami = local.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  key_name = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.nexus.id]
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker
              systemctl enable --now docker
              sudo docker run -d --name nexus --restart always -p 8081:8081 -p 8082:8082 -v nexus-data:/nexus-data sonatype/nexus3
              EOF

  tags = { 
    Name = "${var.project_name}-${var.env}-nexus" 
    Environment = var.env  
    Project = var.project_name 
    Role = "nexus" }
}
