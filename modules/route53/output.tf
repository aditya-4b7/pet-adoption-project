output "zone_id" {
  description = "Route53 Hosted Zone ID"
  value       = aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "NS records for domain"
  value       = aws_route53_zone.main.name_servers
}

output "record_name" {
  description = "Application DNS name"
  value       = aws_route53_record.app.name
}