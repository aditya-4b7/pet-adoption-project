output "target_group_arn" { value = aws_lb_target_group.app.arn }
output "alb_dns" { value = aws_lb.app.dns_name }
output "alb_zone_id" { value = aws_lb.app.zone_id }
output "alb_security_group_id" { value = aws_security_group.alb.id }
