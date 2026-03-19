terraform {
  backend "s3" {
    bucket         = "devops-stage-tf-state-12345"
    key            = "stage/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-stage"
    encrypt        = true
  }
}