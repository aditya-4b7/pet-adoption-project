resource "aws_launch_template" "lt" {
  image_id = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name = var.key_name
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity = 2
  max_size = 3
  min_size = 2

  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]
}