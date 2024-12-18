# Public Subnet NACL
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Public NACL"
  }
}

# Allow HTTP traffic from anywhere
resource "aws_network_acl_rule" "public_http" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# Allow HTTPS traffic from anywhere
resource "aws_network_acl_rule" "public_https" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 110
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Allow all outbound traffic
resource "aws_network_acl_rule" "public_egress" {
  network_acl_id = aws_network_acl.public_nacl.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}


# Private Subnet NACL
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Private NACL"
  }
}

# Allow inbound traffic from Public Subnet 1 to ECS Tasks
resource "aws_network_acl_rule" "private_inbound_5000_sub1" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = false
  cidr_block     = aws_subnet.public_sub1.cidr_block
  from_port      = 5000
  to_port        = 5000
}

# Allow inbound traffic from Public Subnet 2 to ECS Tasks
resource "aws_network_acl_rule" "private_inbound_5000_sub2" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 110
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = false
  cidr_block     = aws_subnet.public_sub2.cidr_block
  from_port      = 5000
  to_port        = 5000
}

# Allow all outbound traffic (to NAT Gateway)
resource "aws_network_acl_rule" "private_egress_nat" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}
