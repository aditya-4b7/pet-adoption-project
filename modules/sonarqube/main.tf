resource "aws_instance" "sonar" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t2.medium"
  subnet_id = var.subnet_id
  key_name = var.key_name
}