provider "aws" {
  region = var.region
}

data "aws_ami" "amazon_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "jenkins_security" {
  name = var.scgrp_jenkins_name

  dynamic "ingress" {
    for_each = var.jenkins_ports
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "public_key" {
  key_name   = "public-key"
  public_key = file(var.path_to_public_key)
}

resource "aws_instance" "jenkins" {
  ami             = data.aws_ami.amazon_ami.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.jenkins_security.name]
  key_name        = aws_key_pair.public_key.key_name
  user_data       = file("${path.module}/userdata.sh")

  tags = {
    Name = var.jenkins_name
  }
}
