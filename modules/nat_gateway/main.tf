resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.env}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.subnet_id
  tags = {
    Name = "${var.env}-nat-gateway"
  }
  depends_on = [aws_eip.nat]
}
