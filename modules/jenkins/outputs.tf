output "jenkins_public_ip" { value = aws_instance.jenkins.public_ip }
output "jenkins_url" { value = "http://${aws_instance.jenkins.public_ip}:8080" }
output "jenkins_sg_id" { value = aws_security_group.jenkins.id }