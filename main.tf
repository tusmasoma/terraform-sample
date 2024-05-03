# Provider設定
provider "aws" {
    profile = "default"
    region = "ap-northeast-1"
}

# VPCの作成
# CIDRブロック10.0.0.0/24のVPCを作成し、DNSサポートとDNSホスト名を有効化します。
resource "aws_vpc" "mamorukun-vpc" {
    cidr_block = "10.0.0.0/24"
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "mamorukun-vpc"
    }
}

# サブネットの作成
# VPC内に4つのサブネットを作成。2つのパブリックサブネットと2つのプライベートサブネット。
resource "aws_subnet" "mamorukun-public-subnet-1a" {
    vpc_id = aws_vpc.mamorukun-vpc.id
    cidr_block = "10.0.0.0/28"
    availability_zone = "ap-northeast-1a"
    tags = {
        Name = "pub-subnet-1a"
    }
}

resource "aws_subnet" "mamorukun-private-subnet-1a" {
    vpc_id = aws_vpc.mamorukun-vpc.id
    cidr_block = "10.0.0.32/28"
    availability_zone = "ap-northeast-1a"
    tags = {
        Name = "private-subnet-1a"
    }
}

resource "aws_subnet" "mamorukun-public-subnet-1c" {
    vpc_id = aws_vpc.mamorukun-vpc.id
    cidr_block = "10.0.0.16/28"
    availability_zone = "ap-northeast-1c"
    tags = {
        Name = "pub-subnet-1c"
    }
}

resource "aws_subnet" "mamorukun-private-subnet-1c" {
    vpc_id = aws_vpc.mamorukun-vpc.id
    cidr_block = "10.0.0.48/28"
    availability_zone = "ap-northeast-1c"
    tags = {
        Name = "private-subnet-1c"
    }
}

# ACLの作成
resource "aws_network_acl" "mamorukun-nacl" {
    vpc_id = aws_vpc.mamorukun-vpc.id
    tags = {
        Name = "mamorukun-nacl"
    }
}

## HTTPトラフィックを許可（インバウンド）
resource "aws_network_acl_rule" "allow_http" {
    network_acl_id = aws_network_acl.mamorukun-nacl.id
    rule_number = 100
    rule_action = "allow"
    egress = false
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_block = "0.0.0.0/0"
}

## HTTPSトラフィックを許可（インバウンド）
resource "aws_network_acl_rule" "allow_https" {
    network_acl_id = aws_network_acl.mamorukun-nacl.id
    rule_number = 110
    rule_action = "allow"
    egress = false
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_block = "0.0.0.0/0"
}

## すべてのその他のトラフィックを拒否（インバウンド）
resource "aws_network_acl_rule" "deny_all" {
    network_acl_id = aws_network_acl.mamorukun-nacl.id
    rule_number = 200
    rule_action = "deny"
    egress = false
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_block = "0.0.0.0/0"
}

## HTTPトラフィックを許可（アウトバウンド）
resource "aws_network_acl_rule" "outbound_allow_http" {
    network_acl_id = aws_network_acl.mamorukun-nacl.id
    rule_number = 100
    rule_action = "allow"
    egress = true
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_block = "0.0.0.0/0"
}

## HTTPSトラフィックを許可（アウトバウンド）
resource "aws_network_acl_rule" "outbound_allow_https" {
    network_acl_id = aws_network_acl.mamorukun-nacl.id
    rule_number = 110
    rule_action = "allow"
    egress = true
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_block = "0.0.0.0/0"
}

## すべてのその他のトラフィックを拒否（アウトバウンド）
resource "aws_network_acl_rule" "outbound_deny_all" {
    network_acl_id = aws_network_acl.mamorukun-nacl.id
    rule_number = 200
    rule_action = "deny"
    egress = true
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_block = "0.0.0.0/0"
}


resource "aws_network_acl_association" "subnet_association_1" {
    network_acl_id = aws_network_acl.mamorukun-nacl.id
    subnet_id = mamorukun-public-subnet-1a.id
}

resource "aws_network_acl_association" "subnet_association_2" {
    network_acl_id = aws_network_acl.mamorukun-nacl.id
    subnet_id = mamorukun-public-subnet-1c.id
}

resource "aws_network_acl_association" "subnet_association_3" {
    network_acl_id = aws_network_acl.mamorukun-nacl.id
    subnet_id = mamorukun-private-subnet-1a.id
}

resource "aws_network_acl_association" "subnet_association_4" {
    network_acl_id = aws_network_acl.mamorukun-nacl.id
    subnet_id = mamorukun-private-subnet-1c.id
}

# インターネットゲートウェイの作成
# VPCにインターネットゲートウェイを関連付け、インターネット接続を可能にします。
resource "aws_internet_gateway" "mamorukun-igw" {
    vpc_id = aws_vpc.mamorukun-vpc.id
    tags = {
        Name = "mamorukun-igw"
    }
}

# ルートテーブルの作成とサブネットへの関連付け。
resource "aws_route_table" "mamorukun-pub-route-table" {
    vpc_id = aws_vpc.mamorukun-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.mamorukun-igw.id
    }
    route {
        cidr_block = "10.0.0.0/24"
        target = "local"
    }
    tags = {
        Name = "mamorukun-pub-route-table"
    }
}

resource "aws_route_table_association" "pub-subnet-1a-assoc" {
    subnet_id = aws_subnet.mamorukun-public-subnet-1a.id
    route_table_id = aws_route_table.mamorukun-pub-route-table.id
}

resource "aws_route_table_association" "pub-subnet-1c-assoc" {
    subnet_id = aws_subnet.mamorukun-public-subnet-1c.id
    route_table_id = aws_route_table.mamorukun-pub-route-table.id
}

resource "aws_route_table" "mamorukun-private-route-table" {
    vpc_id = aws_vpc.mamorukun-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.mamorukun-ngw.id
    }
    route {
        cidr_block = "10.0.0.0/24"
        target = "local"
    }
    tags = {
        Name = "mamorukun-private-route-table"
    }
}

resource "aws_route_table_association" "private-subnet-1a-assoc" {
    subnet_id = aws_subnet.mamorukun-private-subnet-1a.id
    route_table_id = aws_route_table.mamorukun-private-route-table.id
}

resource "aws_route_table_association" "private-subnet-1c-assoc" {
    subnet_id = aws_subnet.mamorukun-private-subnet-1c.id
    route_table_id = aws_route_table.mamorukun-private-route-table.id
}

# NATゲートウェイの作成
resource "aws_eip" "nat-gateway-eip" {
    vpc = true
    tags = {
        Name = "mamorukun-nat-eip"
    }
}

resource "aws_nat_gateway" "mamorukun-ngw" {
    allocation_id = aws_eip.nat-gateway-eip.id
    subnet_id = aws_subnet.mamorukun-public-subnet-1a.id
    tags = {
        Name = "mamorukun-ngw"
    }
}

# EC2インスタンスの作成
resource "aws_eip" "mamorukun-ec2-eip" {
    instance = aws_instance.mamorukun-ec2.id
    domain   = "vpc"
}

resource "aws_instance" "mamorukun-ec2" {
    ami = "ami-0c1de55b79f5aff9b"
    instance_type = "t2.micro"
    disable_api_termination = false # 本番では削除保護を有効にする
    iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
    vpc_security_group_ids  = [aws_security_group.ec2_sg.id]
    subnet_id = aws_subnet.mamorukun-private-subnet-1a.id
    tags = {
        Name = "mamoru"
    }
}

resource "aws_iam_role" "ssm_role" {
  name = "SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "SSMInstanceProfile"
  role = aws_iam_role.ssm_role.name
}

# ALBの作成
resource "aws_lb" "mamorukun-alb" {
  name               = "mamorukun-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.mamorukun-public-subnet-1a.id, aws_subnet.mamorukun-public-subnet-1c.id]

  enable_deletion_protection = false
  enable_http2               = true
  enable_cross_zone_load_balancing = true
  idle_timeout = 60
  access_logs {
    bucket = "mamorukun-alb-logs"
    prefix = "alb"
    enabled = true
  }

  tags = {
    Name = "mamorukun-alb"
  }
}

## ターゲットグループの作成
resource "aws_lb_target_group" "mamorukun-tg" {
  name     = "mamorukun-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.mamorukun-vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "mamorukun-tg"
  }
}

## ターゲットグループとALBの関連付け
resource "aws_lb_listener" "mamorukun-listener" {
  load_balancer_arn = aws_lb.mamorukun-alb.arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mamorukun-tg.arn
  }
}

## EC2インスタンスとターゲットグループの関連付け
resource "aws_lb_target_group_attachment" "mamorukun-tg-attachment" {
  target_group_arn = aws_lb_target_group.mamorukun-tg.arn
  target_id        = aws_instance.mamorukun-ec2.id
  port             = 80
}

# RDSの作成
resource "aws_db_subnet_group" "mamorukun-db-subnet-group" {
  name       = "mamorukun-db-subnet-group"
  subnet_ids = [aws_subnet.mamorukun-private-subnet-1a.id, aws_subnet.mamorukun-private-subnet-1c.id]
}

## Aurora PostgreSQLを作成

# Auroraのクラスターを作成
resource "aws_rds_cluster" "mamorukun-rds-cluster" {
  cluster_identifier = "mamorukun-rds-cluster"
  engine            = "aurora-postgresql"
  engine_version    = "11.5"
  database_name     = "mamorukun"
  master_username   = "mamorukun"
  master_password   = "mamorukun"
  db_subnet_group_name = aws_db_subnet_group.mamorukun-db-subnet-group.name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}

# Auroraのインスタンスを作成
resource "aws_rds_cluster_instance" "mamorukun-rds-instance" {
  cluster_identifier = aws_rds_cluster.mamorukun-rds-cluster.id
  instance_class     = "db.t2.micro"
  engine             = "aurora-postgresql"
  engine_version     = "11.5"
  identifier         = "mamorukun-rds-instance"
  db_subnet_group_name = aws_db_subnet_group.mamorukun-db-subnet-group.name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}

# セキュリティグループとルールの定義
## ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.mamorukun-vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }
}

## EC2
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Security group for EC2 instance with specific rules"
  vpc_id      = aws_vpc.mamorukun-vpc.id

  # インバウンドルール: HTTP (TCP 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # アウトバウンドルール: PostgreSQL (TCP 5432)
  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.rds_sg.id]
  }

  tags = {
    Name = "EC2SecurityGroup"
  }
}

## RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.mamorukun-vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
    }
}

# キーペアの作成
variable "public_key_path" {
  default = "./my-key-pair.pub"
}

resource "aws_key_pair" "auth" {
  key_name   = "terraform-aws"
  public_key = file(var.public_key_path)
}

# 出力
# VPCのIDを出力
output "vpc_id" {
  value = aws_vpc.mamorukun-vpc.id
}

# サブネットのIDを出力
output "public_subnet_1a_id" {
  value = aws_subnet.mamorukun-public-subnet-1a.id
}

output "public_subnet_1c_id" {
  value = aws_subnet.mamorukun-public-subnet-1c.id
}

output "private_subnet_1a_id" {
  value = aws_subnet.mamorukun-private-subnet-1a.id
}

output "private_subnet_1c_id" {
  value = aws_subnet.mamorukun-private-subnet-1c.id
}

# インターネットゲートウェイのIDを出力
output "igw_id" {
  value = aws_internet_gateway.mamorukun-igw.id
}

# ルートテーブルのIDを出力
output "pub_route_table_id" {
  value = aws_route_table.mamorukun-pub-route-table.id
}

output "private_route_table_id" {
  value = aws_route_table.mamorukun-private-route-table.id
}

# NATゲートウェイのIDを出力
output "nat_gateway_id" {
  value = aws_nat_gateway.mamorukun-ngw.id
}

# EC2インスタンスのIDを出力
output "ec2_instance_id" {
  value = aws_instance.mamorukun-ec2.id
}

# ALBのIDを出力
output "alb_id" {
  value = aws_lb.mamorukun-alb.id
}

# ターゲットグループのIDを出力
output "tg_id" {
  value = aws_lb_target_group.mamorukun-tg.id
}

# RDSのクラスターIDを出力
output "rds_cluster_id" {
  value = aws_rds_cluster.mamorukun-rds-cluster.id
}

# RDSのインスタンスIDを出力
output "rds_instance_id" {
  value = aws_rds_cluster_instance.mamorukun-rds-instance.id
}

# セキュリティグループのIDを出力
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

# Auroraのエンドポイントを出力
output "rds_endpoint" {
  value = aws_rds_cluster.mamorukun-rds-cluster.endpoint
}

# ALBのDNS名を出力
output "alb_dns_name" {
  value = aws_lb.mamorukun-alb.dns_name
}

# EC2のパブリックIPを出力
output "ec2_public_ip" {
  value = aws_eip.mamorukun-ec2-eip.public_ip
}