resource "aws_security_group" "ec2_sg" {
  name        = "${var.name}-${var.env}"
  description = "Security group for ${var.env} environment"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-${var.name}-${var.env}"
  }
}

resource "aws_security_group" "ec2_web_to_db_sg" {
  name        = "ec2-web-to-db-${var.env}"
  description = "Allow web traffic from ALB and allow DB access to RDS"
  vpc_id      = var.vpc_id

  # インバウンドルール: ALBからのHTTP (TCP 80)
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # アウトバウンドルール: RDSへのPostgreSQL (TCP 5432)
  egress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.rds_sg.id]
  }

  tags = {
    Name = "ec2-web-to-db-${var.env}"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_web_to_db_sg.id]
  }

  tags = {
    Name = "rds-sg"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_web_to_db_sg.id]
  }

  tags = {
    Name = "alb-sg"
  }
}