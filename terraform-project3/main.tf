provider "aws" {
  region = "us-east-2"
}

provider "vault" {
  address = "http://3.142.221.82:8200"
  skip_child_token = true
  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "7154dbc7-182c-10e6-b011-8602d3e1b432"
      secret_id = "5c6be85a-ecf8-70d4-490c-469e29e8bb95"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "laveena"
  name  = "test-secret"
}

resource "aws_instance" "instance" {
  ami = "ami-06971c49acd687c30"
  instance_type = "t2.micro"
  tags = {
    Name = data.vault_kv_secret_v2.example.data["username"]
  }
}