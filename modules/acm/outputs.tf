output "certificate_arn" {
  description = "ACM Certificate ARN"
  value       = aws_acm_certificate.cert.arn
}

output "certificate_status" {
  description = "Certificate validation status"
  value       = aws_acm_certificate_validation.cert_validation.validation_status
}