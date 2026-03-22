resource "aws_lb" "app" {
  load_balancer_type = "application"
  subnets = var.subnet_ids
}

resource "aws_lb_target_group" "tg" {
  port = 8080
  protocol = "HTTP"
  vpc_id = var.vpc_id
}