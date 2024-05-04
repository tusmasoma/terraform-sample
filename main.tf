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


# キーペアの作成
variable "public_key_path" {
  default = "./my-key-pair.pub"
}

resource "aws_key_pair" "auth" {
  key_name   = "terraform-aws"
  public_key = file(var.public_key_path)
}


# GitHub Copilot、パフォーマンスを向上させるためにこの構成を改善するにはどうすればよいですか?
# 1. モジュールを使用してコードを再利用する
# 2. パラメータを使用してコードを柔軟にする
# 3. リソースの命名規則を統一する
# 4. ドキュメントを追加してコードを説明する
# 5. テストを追加してコードを検証する
# 6. デプロイメントパイプラインを追加してコードを自動化する
# 7. ログとメトリクスを追加してコードを監視する
# 8. セキュリティを追加してコードを保護する
# 9. コストを追加してコードを最適化する
# 10. バージョン管理を追加してコードを追跡する

# この構成を改善するために、どのツールやサービスを使用することができますか?
# 1. Terraform Cloud
# 2. AWS CloudFormation
# 3. AWS CDK
# 4. GitHub Actions
# 5. AWS CodePipeline
# 6. AWS CloudWatch
# 7. AWS Config
# 8. AWS Security Hub
# 9. AWS Cost Explorer
# 10. GitHub