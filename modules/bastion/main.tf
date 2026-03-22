resource "aws_instance" "bastion" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id = var.public_subnet
  key_name = var.key_name
}