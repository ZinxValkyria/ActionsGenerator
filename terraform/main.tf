# Specify the AWS provider and region
provider "aws" {
  region = "eu-west-1" # Set your desired AWS region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "Actions_Template-tf-vpc"
  }
}

# Create Public Subnet 1
resource "aws_subnet" "public_sub1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24" # Adjust as needed
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 1"
  }
}

# Create Public Subnet 2
resource "aws_subnet" "public_sub2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24" # Adjust as needed
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 2"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "actions_template_internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Actions Template Internet Gateway"
  }
}
