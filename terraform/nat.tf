

# Define a public subnet
resource "aws_subnet" "public_sub" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet"
  }
}

# Define a private subnet
resource "aws_subnet" "private_sub" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

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

# Define the NAT Gateway
resource "aws_nat_gateway" "my_nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_sub.id

  tags = {
    Name = "My NAT Gateway"
  }

  depends_on = [aws_internet_gateway.actions_template_internet_gateway]
}

# Define the route table for the private subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.my_nat_gw.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

# Associate the route table with the private subnet
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_sub.id
  route_table_id = aws_route_table.private_rt.id
}

# Security Group for instances in the private subnet
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"] # Allow HTTP traffic from the private subnet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private Security Group"
  }
}

# Example of an EC2 instance in the private subnet (optional)
resource "aws_instance" "private_instance" {
  ami                    = "ami-0c7217cdde317cfec" # Replace with your desired AMI ID
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_sub.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "Private Instance"
  }
}
