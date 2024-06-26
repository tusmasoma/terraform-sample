data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.system}-${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.system}-${var.env}-igw"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.cidr_public)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.cidr_public, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.system}-${var.env}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.cidr_private)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.cidr_private, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.system}-${var.env}-private-${count.index + 1}"
  }
}

resource "aws_subnet" "secure" {
  count             = length(var.cidr_secure)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.cidr_secure, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.system}-${var.env}-secure-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.system}-${var.env}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.cidr_public)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.system}-${var.env}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.cidr_private)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "secure" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.system}-${var.env}-secure-rt"
  }
}

resource "aws_route_table_association" "secure" {
  count          = length(var.cidr_secure)
  subnet_id      = element(aws_subnet.secure[*].id, count.index)
  route_table_id = aws_route_table.secure.id
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.vpc.id
  subnet_ids = compact(
    flatten([
      aws_subnet.public.*.id,
      aws_subnet.private.*.id,
      aws_subnet.secure.*.id
    ])
  )
  tags = {
    Name = "${var.system}-${var.env}-nacl"
  }
}

resource "aws_network_acl_rule" "inbound_allow_http" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "inbound_allow_https" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 110
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "inbound_deny_all" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 200
  protocol       = "-1"
  rule_action    = "deny"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "outbound_allow_http" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "outbound_allow_https" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 110
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "outbound_deny_all" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 200
  protocol       = "-1"
  rule_action    = "deny"
  egress         = true
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}
