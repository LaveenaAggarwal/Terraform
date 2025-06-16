provider "aws" {
  region = "us-east-2"
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to use"
  type        = map(string)
  default = {
    "dev" = "t2.micro",
    "stage" = "t2.small",
    "prod" = "t2.medium"
  }
}

module "test_ec2_instance" {
  source        = "./module/ec2-instance"
  ami_id       = var.ami_id
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
}