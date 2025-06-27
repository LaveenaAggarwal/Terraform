resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.my_vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id= aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "RTA1" {
  subnet_id = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "RTA2" {
  subnet_id = aws_subnet.sub2.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "sg" {
  name_prefix = "test-sg-"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "myBucket" {
  bucket = "my-unique-bucket-name-08011992"
}

resource "aws_key_pair" "name" {
  key_name = "test-key-pair"
  public_key = file("c:/Users/Laveena/.ssh/id_rsa.pub")
}

resource "aws_instance" "example1" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.sub1.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = aws_key_pair.name.key_name
  user_data_base64 =  base64encode(file("userdata1.sh"))
  tags = {
    Name = "example-instance1"
  }
}

resource "aws_instance" "example2" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.sub2.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name = aws_key_pair.name.key_name
  user_data_base64 = base64encode(file("userdata2.sh"))
  tags = {
    Name = "example-instance2"
  }
}

resource "aws_lb" "my_lb" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [aws_subnet.sub1.id, aws_subnet.sub2.id] 
}

resource "aws_lb_target_group" "TG" {
  name     = "target-group1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group_attachment" "atttachment1" {
  target_group_arn = aws_lb_target_group.TG.arn
  target_id        = aws_instance.example1.id
  port             = 80 
}

resource "aws_lb_target_group_attachment" "atttachment2" {
  target_group_arn = aws_lb_target_group.TG.arn
  target_id        = aws_instance.example2.id
  port             = 80 
}

resource "aws_lb_listener" "Listerner" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG.arn
  } 
}

output "awsloadbalancer_dns_name" {
  value = aws_lb.my_lb.dns_name
}