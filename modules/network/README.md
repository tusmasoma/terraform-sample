# ネットワークモジュール

## 概要
このTerraformモジュールは、AWSのネットワークインフラストラクチャの設定と管理を担当しています。これには、仮想プライベートクラウド（VPC）、サブネット（公開、プライベート、セキュア）、インターネットゲートウェイ、ルートテーブル、ネットワークアクセスコントロールリスト（NACL）の作成が含まれます。モジュールは、設定可能な設定を持つ異なる環境（ステージング、本番）をサポートするように設計されています。

## 外観
![3](https://github.com/tusmasoma/terraform-sample/assets/104899572/f3cb94ce-ebd6-41e3-a857-b7d180b68ef7)

## モジュール内容
モジュールには、堅牢で安全なAWSネットワーク設定に不可欠ないくつかのリソースが含まれています：

- **VPC**: AWS内に分離されたネットワーク環境を提供します。
- **インターネットゲートウェイ**: AWS VPCをインターネットに接続し、VPC内のインスタンスと外部世界との通信を可能にします。
- **サブネット**: 公開、プライベート、セキュアゾーンにVPCを分割し、インフラストラクチャ内の異なる役割を担います。
- **ルートテーブル**: サブネットから適切な目的地へのネットワークトラフィックを指示します。
- **ネットワークACL**: トラフィックフィルタリングルールを通じてサブネットレベルでのセキュリティ層を提供します。

## 使用方法

このモジュールをTerraform環境設定（`stage`、`prod`）に組み込むには、必要なパラメータを指定して環境固有の`main.tf`ファイルで参照します。以下はモジュールを使用する例です：

```hcl
module "network" {
  source = "../modules/network"
  
  cidr_vpc          = var.cidr_vpc
  cidr_public       = var.cidr_public
  cidr_private      = var.cidr_private
  cidr_secure       = var.cidr_secure
  system            = var.system
  env               = var.env
}
```

### パラメータ
- **cidr_vpc**: VPCのCIDRブロック。
- **cidr_public**: 公開サブネットのCIDRブロックリスト。
- **cidr_private**: プライベートサブネットのCIDRブロックリスト。
- **cidr_secure**: セキュアサブネットのCIDRブロックリスト。
- **system**: リソースタグ付けに使用されるシステム識別子。
- **env**: 環境識別子（例：`stage`、`prod`）。

## 作成されるリソース
- `aws_vpc.vpc`: メインのVPC。
- `aws_internet_gateway.igw`: VPCに接続されたインターネットゲートウェイ。
- `aws_subnet.public`: 公開サブネット。
- `aws_subnet.private`: プライベートサブネット。
- `aws_subnet.secure`: セキュアサブネット。
- `aws_route_table.public`: 公開サブネット用のルートテーブル。
- `aws_route_table.private`: プライベートサブネット用のルートテーブル。
- `aws_route_table.secure`: セキュアサブネット用のルートテーブル。
- `aws_network_acl.main`: トラフィックフローを管理するルールを備えたネットワークACL。

## ネットワークACLルール
- **インバウンドとアウトバウンドルール**: HTTP (80) と HTTPS (443) トラフィックを許可するルールと、すべてのその他のトラフィックを拒否するデフォルトルールを含み、厳格なトラフィックフィルタリングを実施します。
