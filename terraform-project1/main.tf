provider "aws" {
  region = "us-east-2"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_key_pair" "key" {
  key_name = "test-terrafom"
  public_key = file("C:/Users/Laveena/.ssh/id_rsa.pub")
}

resource "aws_vpc" "myVPC" {
  cidr_block = var.cidr
}

resource "aws_subnet" "mySubnet" {
    vpc_id = aws_vpc.myVPC.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-2a"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myVPC.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myVPC.id
  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "RTA" {
  route_table_id = aws_route_table.RT.id
  subnet_id = aws_subnet.mySubnet.id
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.myVPC.id
  name = "test-terraform-sg"
  ingress {
    description = "SSH"
    to_port = 22
    from_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    to_port = 80
    from_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    to_port = 0
    from_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "server" {
  ami = "ami-06c8f2ec674c67112"
  instance_type = "t2.micro"
  key_name = aws_key_pair.key.key_name
  subnet_id = aws_subnet.mySubnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = "my-instance-test"
  }

# How to connect to an EC2 instance using SSH with Terraform
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("C:/Users/Laveena/.ssh/id_rsa")
    host = self.public_ip
  }

  # inline is used to specify a list of shell commands that Terraform runs directly on the remote instance in sequence.
  provisioner "remote-exec" {
    inline = [
      "echo 'Welcome !!!!'",
      "sudo yum update -y",
      "sudo yum install -y git python3 python3-pip",
      "cd /home/ec2-user && if [ -d 'Python' ]; then cd Python && git pull; else git clone https://github.com/LaveenaAggarwal/Python.git; fi",
      "cd /home/ec2-user/Python/Python-Project1 && sudo pip3 install -r requirements.txt",
      "cd /home/ec2-user/Python/Python-Project1 && sudo python3 main.py &"
    ]
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.server.id
}