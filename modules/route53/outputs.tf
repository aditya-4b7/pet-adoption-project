output "zone_id" {
  value = var.zone_id
}

output "record_name" {
  value = aws_route53_record.app.name
}