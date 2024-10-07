
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.actions_template_internet_gateway.id
  }
}

resource "aws_route_table_association" "rt_asc" {
  subnet_id      = aws_subnet.public_sub1.id
  route_table_id = aws_route_table.public_rt.id
}

