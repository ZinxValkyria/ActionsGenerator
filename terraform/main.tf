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
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 1"
  }
}

# Create Public Subnet 2
resource "aws_subnet" "public_sub2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 2"
  }
}

# Create Private Subnet 1
resource "aws_subnet" "private_sub1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24" # Private range
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet 1"
  }
}

# Create Private Subnet 2
resource "aws_subnet" "private_sub2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24" # Private range
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet 2"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main Internet Gateway"
  }
}

# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "NAT Gateway EIP"
  }
}

# Create a NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_sub1.id # Place the NAT Gateway in a public subnet

  tags = {
    Name = "NAT Gateway"
  }
}

# Create Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Associate Route Table with Public Subnet 1
resource "aws_route_table_association" "public_association_sub1" {
  subnet_id      = aws_subnet.public_sub1.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate Route Table with Public Subnet 2
resource "aws_route_table_association" "public_association_sub2" {
  subnet_id      = aws_subnet.public_sub2.id
  route_table_id = aws_route_table.public_rt.id
}

# Create Route Table for Private Subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

# Associate Route Table with Private Subnet 1
resource "aws_route_table_association" "private1_association" {
  subnet_id      = aws_subnet.private_sub1.id
  route_table_id = aws_route_table.private_rt.id
}

# Associate Route Table with Private Subnet 2
resource "aws_route_table_association" "private2_association" {
  subnet_id      = aws_subnet.private_sub2.id
  route_table_id = aws_route_table.private_rt.id
}
