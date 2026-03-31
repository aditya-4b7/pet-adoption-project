output "nexus_public_ip" { value = aws_instance.nexus.public_ip }
output "nexus_url" { value = "http://${aws_instance.nexus.public_ip}:8081" }
