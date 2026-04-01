output "asg_name" { value = aws_autoscaling_group.app.name }
output "app_security_group_id" { value = aws_security_group.app.id }

output "asg_arn" {
  description = "Auto Scaling Group ARN"
  value       = aws_autoscaling_group.app.arn
}

output "launch_template_id" {
  description = "Launch template ID"
  value       = aws_launch_template.app.id
}