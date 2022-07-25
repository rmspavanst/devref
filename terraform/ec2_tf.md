# https://levelup.gitconnected.com/devops-how-to-create-an-ec2-instance-with-terraform-a1f8285ee5f7

# How To Create An EC2 Instance With Terraform

1. Create IAM User
2. Create Project
    $ mkdir terraform-ec2-nginx
    $ cd terraform-ec2-nginx
    $ code .

3. Project Structure

$ mkdir network ec2
$ touch main.tf providers.tf locals.tf terraform.tfvars
$ touch vpc/data.tf vpc/main.tf vpc/outputs.tf vpc/variables.tf
$ touch ec2/main.tf ec2/outputs.tf ec2/variables.tf ec2/userdata.json

# Environment Variables
Here is where we store our Access Key and Secret Access Key of the user we just created on the IAM dashboard. Just insert them between the quotes

vi terraform.tfvars

aws_access_key = "YOUR_ACCESS_KEY"
aws_secret_key = "YOUR_SECRET_ACCESS_KEY"
access_ip      = "0.0.0.0/0"


# Variables

vi variables.tf

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "access_ip" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}


# Providers

vi providers.tf

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


# Locals

vi locals.tf

locals {
  vpc_cidr = "10.123.0.0/16"
}

locals {
  security_groups = {
    public = {
      name        = "public_sg"
      description = "Security group for Public Access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
        https = {
          from        = 443
          to          = 443
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
  }
}


4. Create a VPC
Now we going to configure the first of two modules we going to have.

# Variables

vi network/variables.tf

variable "vpc_cidr" {}
variable "access_ip" {}
variable "security_groups" {}


# Data Sources

vi network/data.tf

# Get Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}


# Resources

vi network/main.tf

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "VPC"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create a Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 2)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Public Subnet"
  }
}

# Associate the Public Route Table to the Public Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "IGW"
  }
}

# Create a Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Public RT"
  }
}

# Create a Route
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Create Security Groups
resource "aws_security_group" "sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress

    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Outputs

vi network/outputs.tf

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_sg" {
  value = aws_security_group.sg["public"].id
}

output "public_subnet" {
  value = aws_subnet.public_subnet.id
}


# Add VPC as Module

vi main.tf

module "network" {
  source          = "./network"
  access_ip       = var.access_ip
  vpc_cidr        = local.vpc_cidr
  security_groups = local.security_groups
}

# Testing the VPC
If you want to test the VPC configuration already, then you can do that. Scroll down to the Command section of this article. But this is very optional. I going to explain the commands after setting up the EC2 instance.



# EC2 Instance
Now, let’s continue with the configuration of our EC2 instance. We won’t face too many new keywords here, so this is quickly done.

# Variables

vi ec2/variables.tf

variable "public_sg" {}
variable "public_subnet" {}

# User Data

vi ec2/userdata.tpl

#!/bin/bash
sudo apt update
sudo apt install git nginx build-essential apache2-utils -y

# Resources
So this file is very important. Here, we configure our EC2 instance. So what we do here is create a Key Pair, which we also download into our root directory. We need that Key Pair to connect to our EC2 instance later. Also, we set up the EC2 instance and associate an Elastic IP to the server.

vi ec2/main.tf

# Get Availability Zones
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generate a Private Key and encode it as PEM.
resource "aws_key_pair" "key_pair" {
  key_name   = "key"
  public_key = tls_private_key.key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.key.private_key_pem}' > ./key.pem"
  }
}

# Create a EC2 Instance (Ubuntu 20)
resource "aws_instance" "node" {
  instance_type          = "t2.micro" # free instance
  ami                    = "ami-0d527b8c289b4af7f"
  key_name               = aws_key_pair.key_pair.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnet

  tags = {
    Name = "TF Generated EC2"
  }

  user_data = file("${path.root}/ec2/userdata.tpl")

  root_block_device {
    volume_size = 10
  }
}

# Create and assosiate an Elastic IP
resource "aws_eip" "eip" {
  instance = aws_instance.node.id
}


# Outputs

vi ec2/outputs.tf

output "ec2_public_dns" {
  value = aws_instance.node.public_dns
}

output "ec2_public_ip" {
  value = aws_eip.eip.public_ip
}



# Add EC2 as Module

Now, we need to add the EC2 configuration as a module. As I said, we going to add some variables since it requires some variables.

Let’s change the file main.tf inside our root directory from

vi main.tf

module "network" {
  source          = "./network"
  access_ip       = var.access_ip
  vpc_cidr        = local.vpc_cidr
  security_groups = local.security_groups
}

to 

module "network" {
  source          = "./network"
  access_ip       = var.access_ip
  vpc_cidr        = local.vpc_cidr
  security_groups = local.security_groups
}

module "ec2" {
  source        = "./ec2"
  public_sg     = module.network.public_sg
  public_subnet = module.network.public_subnet
}



# After you have done the changes, run terraform init, terraform validate, terraform plan, and terraform apply to apply the changes you have done.

# If you want to destroy your whole configuration, then you need to run terraform destory.
