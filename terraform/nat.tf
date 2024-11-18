
# Define the NAT Gateway
resource "aws_nat_gateway" "my_nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_sub1.id

  tags = {
    Name = "My NAT Gateway"
  }

  depends_on = [aws_internet_gateway.actions_template_internet_gateway]
}

