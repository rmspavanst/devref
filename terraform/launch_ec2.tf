# This is the full code for provisioning an ec2 instance in AWS.

provider "aws" {
  region = "us-west-2"
}

terraform {
  required_version = ">= 1.0.7"
}

variable "key_path" {
  default = "~/.ssh/id_rsa.pub"
}

resource "aws_key_pair" "my-pub-key" {
  key_name   = "my-pub-key"
  public_key = file("${var.key_path}")
}

resource "aws_instance" "instance" {
  ami                         = "ami-0ddb956ac6be95761"
  instance_type               = "t2.small"
  key_name                    = aws_key_pair.my-pub-key.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = "subnet-xxxxxxx"
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 50
    delete_on_termination = true
  }

  tags = {
    Name = "Citizix-Debian-Server"
  }
}

resource "aws_security_group" "sg" {
  name        = "Citizix-Server-SG"
  description = "Restrictions for Citizix server"

  ingress {
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

  vpc_id = "vpc-xxxxxx"

  tags = {
    Name = "Citizix-Server-SG"
  }
}

output "instance-private-ip" {
  value = aws_instance.instance.private_ip
}

output "instance-public-ip" {
  value = aws_instance.instance.public_ip
}



#Creating resources


# terraform init
# terraform plan
# terraform apply