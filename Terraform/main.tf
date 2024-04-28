terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

// instancja EC2
resource "aws_instance" "tic_tac_toe_ec2" {
  ami                    = "ami-04e5276ebb8451442" // Amazon Machine Image
  instance_type          = "t2.micro"
  key_name               = "key-demo"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "Tic-Tac-Toe EC2 tf"
  }

  user_data = "${file("install.sh")}"
}

// sieć VPC (Virtual Private Cloud)
resource "aws_vpc" "vpc_tf" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC Tic-Tac-Toe tf"
  }
}

// podsieć
resource "aws_subnet" "subnet_tf" {
  vpc_id     = aws_vpc.vpc_tf.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "SUBNET Tic-Tac-Toe tf"
  }
}

// internet gateway
resource "aws_internet_gateway" "ig_tf" {
  vpc_id = aws_vpc.vpc_tf.id

  tags = {
    Name = "GATEWAY Tic-Tac-Toe tf"
  }
}

// route table 
resource "aws_route_table" "rt_tf" {
  vpc_id = aws_vpc.vpc_tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_tf.id
  }

  tags = {
    Name = "ROUTE TABLE Tic-Tac-Toe tf"
  }
}

// połączenie ig z rt
resource "aws_route_table_association" "subnet_tf" {
  subnet_id      = aws_subnet.subnet_tf.id
  route_table_id = aws_route_table.rt_tf.id
}


// security group
resource "aws_security_group" "main" {
  // reguły wychozące - wszystko dostępne
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // reguły przychodzące - konkretne porty
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    description = "Backend"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 5173
    to_port     = 5173
    protocol    = "tcp"
    description = "Frontend"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name = "key-demo"
  public_key = "${file("key-demo.pub")}"
}