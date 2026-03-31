# resource "aws_security_group" "alb" {
#   name = "${var.project_name}-${var.env}-alb-sg"
#   vpc_id = var.vpc_id
#   ingress { 
#   from_port = 80 
#   to_port = 80 
#   protocol = "tcp" 
#   cidr_blocks = ["0.0.0.0/0"] 
#   }
#   ingress { 
#     from_port = 443 
#     to_port = 443 
#     protocol = "tcp" 
#     cidr_blocks = ["0.0.0.0/0"] 
#     }
#   egress { 
#     from_port = 0 
#     to_port = 0 
#     protocol = "-1" 
#     cidr_blocks = ["0.0.0.0/0"] 
#   }
#   tags = { Name = "${var.project_name}-${var.env}-alb-sg" 
#   Environment = var.env 
#   Project = var.project_name }
# }
# resource "aws_lb" "app" {
#   name = substr("${var.project_name}-${var.env}-alb", 0, 32)
#   internal = false
#   load_balancer_type = "application"
#   security_groups = [aws_security_group.alb.id]
#   subnets = var.subnet_ids
#   tags = { Name = "${var.project_name}-${var.env}-alb" 
#   Environment = var.env 
#   Project = var.project_name }
# }

# resource "aws_lb_target_group" "app" {
#   name = substr("${var.project_name}-${var.env}-tg", 0, 32)
#   port = 8080
#   protocol = "HTTP"
#   vpc_id = var.vpc_id
#   target_type = "instance"
#   health_check { 
#     enabled = true 
#     healthy_threshold = 2 
#     unhealthy_threshold = 3 
#     interval = 30 
#     timeout = 5 
#     path = "/pet-adoption/" 
#     matcher = "200-399" 
#     }

#     tags = { 

#       Name = "${var.project_name}-${var.env}-tg" 
#       Environment = var.env 
#       Project = var.project_name }
# }


# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.app.arn
#   port = 80
#   protocol = "HTTP"
#   default_action {
#     type = "redirect"
#     redirect { 
#       port = "443" 
#       protocol = "HTTPS" 
#       status_code = "HTTP_301" 
#       }
#   }
# }

resource "aws_security_group" "alb" {
  name   = "${var.project_name}-${var.env}-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.env}-alb-sg"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_lb" "app" {
  name               = substr("${var.project_name}-${var.env}-alb", 0, 32)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.env}-alb"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_lb_target_group" "app" {
  name        = substr("${var.project_name}-${var.env}-tg", 0, 32)
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
    timeout             = 5
    path                = "/pet-adoption/"
    matcher             = "200-399"
  }

  tags = {
    Name        = "${var.project_name}-${var.env}-tg"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

 