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
resource "aws_eip" "aws-tf-eip" {
    instance = aws_instance.aws-tf-web.id
    domain   = "vpc"
}

resource "aws_instance" "aws-tf-web" {
    ami = "ami-0ce6d733b60360890"
    instance_type = "t2.micro"
    disable_api_termination = false
    key_name = aws_key_pair.auth.key_name
    vpc_security_group_ids  = [aws_security_group.aws-tf-web.id]
    subnet_id = aws_subnet.aws-tf-public-subnet-1a.id
    tags = {
        Name = "aws-tf-web"
    }
}

# セキュリティグループとルールの定義
resource "aws_security_group" "aws-tf-web" {
    name = "aws-tf-web"
    description = "aws-tf-web_sg"
    vpc_id = aws_vpc.aws-tf-vpc.id
    tags = {
        Name = "aws-tf-web"
    }
}

resource "aws_security_group_rule" "inbound_http" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
        "0.0.0.0/0",
    ]
    security_group_id = aws_security_group.aws-tf-web.id
}

resource "aws_security_group_rule" "inbound_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  security_group_id = aws_security_group.aws-tf-web.id
}

resource "aws_security_group_rule" "outbound_all" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = -1
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  security_group_id = aws_security_group.aws-tf-web.id
}

# キーペアの作成
variable "public_key_path" {
  default = "./my-key-pair.pub"
}

resource "aws_key_pair" "auth" {
  key_name   = "terraform-aws"
  public_key = file(var.public_key_path)
}
