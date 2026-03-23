output "sonarqube_instance_id" {
  description = "SonarQube instance ID"
  value       = aws_instance.sonar.id
}

output "sonarqube_public_ip" {
  description = "Public IP of SonarQube server"
  value       = aws_instance.sonar.public_ip
}

output "sonarqube_private_ip" {
  description = "Private IP of SonarQube server"
  value       = aws_instance.sonar.private_ip
}

output "sonarqube_url" {
  description = "SonarQube UI URL"
  value       = "http://${aws_instance.sonar.public_ip}:9000"
}

output "sonarqube_sg_id" {
  description = "Security group ID of SonarQube"
  value       = aws_security_group.sonar_sg.id
}