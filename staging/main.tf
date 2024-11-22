terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "random_pet" "sg" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "FirstGHAEC2" {
  ami                    = "ami-0596d807260f25fc1"
  instance_type          = "t2.micro"
#  key_name               = aws_key_pair.week4KP.key_name
#  vpc_security_group_ids = [aws_security_group.ACSFirstSG.id]

   tags = {
     name = "GHACS730"
     env  = "Test"
  }
}


resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  description = "Ingress on port 8000"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["1.2.3.4/32"]
  }
}

