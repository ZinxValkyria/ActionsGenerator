# Create a route table for the public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.actions_template_internet_gateway.id
  }
}

# Associate the public route table with Public Subnet 1
resource "aws_route_table_association" "rt_asc" {
  subnet_id      = aws_subnet.public_sub1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "rt_asc_sub2" {
  subnet_id      = aws_subnet.public_sub2.id
  route_table_id = aws_route_table.public_rt.id
}
