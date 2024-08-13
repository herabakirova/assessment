provider "aws" {
  region = "us-east-2"
}

data "aws_ami" "amazon_ami" {
  most_recent      = true
  owners           = ["amazon"]
 
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
  name        = "jenkins_security"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "public_key" {
  key_name = "public-key"
  public_key = file("/Users/herabakirova/.ssh/id_rsa.pub")
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.amazon_ami.id
  instance_type = "t2.xlarge"
  security_groups = [aws_security_group.jenkins_security.name]
  key_name = aws_key_pair.public_key.key_name
  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "Jenkins"
  }
}
