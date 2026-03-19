terraform {
  backend "s3" {
    bucket         = "devops-prod-tf-state-12345"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-prod"
    encrypt        = true
  }
}