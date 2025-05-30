terraform {
  backend "s3" {
    bucket = "laveena-terraform-state-bucket"
    key = "terraform/state"
    region = "us-east-2"
  }
}