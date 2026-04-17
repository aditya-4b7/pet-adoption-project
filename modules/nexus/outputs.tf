# output "nexus_public_ip" { value = aws_instance.nexus.public_ip }
# output "nexus_url" { value = "http://${aws_instance.nexus.public_ip}:8081" }
output "nexus_instance_id" {
  description = "Nexus instance ID"
  value       = aws_instance.nexus.id
}

output "nexus_public_ip" {
  description = "Public IP of Nexus server"
  value       = aws_instance.nexus.public_ip
}

output "nexus_private_ip" {
  description = "Private IP of Nexus server"
  value       = aws_instance.nexus.private_ip
}

output "nexus_url" {
  description = "Nexus UI URL"
  value       = "http://${aws_instance.nexus.private_ip}:8081"
}

output "nexus_sg_id" {
  description = "Security group ID of Nexus"
  value       = aws_security_group.nexus.id
}

variable "bastion_security_group_id" {
  type = string
}
