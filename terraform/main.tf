provider "aws" {
  region = "eu-west-1" # Set your desired AWS region
}

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

# Define a private subnet
resource "aws_subnet" "private_sub" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "Private Subnet"
  }
}


# Define an Elastic IP for the NAT Gateway
resource "aws_eip" "nat_eip" {

  tags = {
    Name = "NAT Elastic IP"
  }
}

# Define the Internet Gateway
resource "aws_internet_gateway" "actions_template_internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Actions Template Internet Gateway"
  }
}

