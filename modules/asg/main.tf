data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

locals {
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ssm_parameter.al2023_ami.value
}
resource "aws_security_group" "app" {
  name = "${var.project_name}-${var.env}-app-sg"
  vpc_id = var.vpc_id
  ingress { 
    from_port = 8080 
    to_port = 8080 
    protocol = "tcp" 
    security_groups = [var.alb_security_group] 
    }
  ingress { 
    from_port = 22 
    to_port = 22 
    protocol = "tcp" 
    security_groups = [var.bastion_security_group] 
    }
  egress { 
    from_port = 0 
    to_port = 0 
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
    }
  tags = { 
    Name = "${var.project_name}-${var.env}-app-sg" 
    Environment = var.env 
    Project = var.project_name 
    }
}
resource "aws_launch_template" "app" {
  name_prefix = "${var.project_name}-${var.env}-lt-"
  image_id = local.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.app.id]
  user_data = base64encode(<<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker awscli python3
              systemctl enable --now docker
              usermod -aG docker ec2-user
              mkdir -p /opt/pet-adoption
              EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = { 
      Name = "${var.project_name}-${var.env}-app" 
      Environment = var.env 
      Project = var.project_name 
      Role = "app" 
      }
  }
}
resource "aws_autoscaling_group" "app" {
  name = "${var.project_name}-${var.env}-asg"
  desired_capacity = var.desired_capacity
  max_size = var.max_size
  min_size = var.min_size
  vpc_zone_identifier = var.subnet_ids
  target_group_arns = [var.target_group_arn]
  health_check_type = "ELB"
  health_check_grace_period = 300
  launch_template { 
    id = aws_launch_template.app.id 
    version = "$Latest" 
    }
    
  tag {
    key   = "Name"
    value = "${var.project_name}-${var.env}-app"
    propagate_at_launch = true
  }
  tag {
    key   = "Role"
    value = "app"
    propagate_at_launch = true
  }
  tag {
    key   = "Environment"
    value = var.env
    propagate_at_launch = true
  }
  tag {
    key   = "Project"
    value = var.project_name
    propagate_at_launch = true
  }
}
