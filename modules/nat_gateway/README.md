# NAT Gateway モジュール

## 概要
このTerraformモジュールは、AWS VPC内にNATゲートウェイとElastic IP（EIP）をプロビジョニングします。NATゲートウェイを使用すると、プライベートサブネット内のインスタンスがインターネットまたは他のAWSサービスに対してアウトバウンドトラフィックを開始できるようになり、インターネットからの不要なインバウンドトラフィックは防げます。

## 特徴
- **安全なインターネット接続**: プライベートサブネットのEC2インスタンスにインターネットアクセスを提供しながら、それらを直接インターネットに露出させません。
- **Elastic IP関連付け**: NATゲートウェイにElastic IPを自動的に関連付け、一貫したパブリックIPアドレスを確保します。
- **高可用性**: 複数のアベイラビリティゾーンへの展開をサポートし、障害耐性を強化します。

## モジュール内容
- `main.tf`: NATゲートウェイとElastic IPの設定を含むメインの設定ファイル。
- `variables.tf`: モジュールで使用される入力変数を定義します。
- `outputs.tf`: 他のリソースやモジュールに役立つかもしれない出力値を定義します。

## 使用方法
このモジュールをTerraform環境で使用するには、適切なパラメータを持つメインのTerraform設定ファイルに含めます。以下は、Terraform設定にNATゲートウェイモジュールを含める例です。

```hcl
module "nat_gateway" {
  source       = "./modules/nat_gateway"
  subnet_id    = var.subnet_id
  environment  = var.environment
}
```

## 必要な変数
- `subnet_id`: NATゲートウェイが配置されるサブネットのID。これはパブリックサブネットであるべきです。
- `environment`: 環境の記述子で、リソース名にプレフィックスをつけて一意性を保証するために使用します。

## 出力
- `nat_gateway_id`: 作成されたNATゲートウェイのID。
- `nat_gateway_public_ip`: NATゲートウェイに関連付けられた公衆IPアドレス。

## 設定例
```hcl
provider "aws" {
  region = "us-west-2"
}

variable "subnet_id" {
  description = "The ID of the public subnet where the NAT Gateway will be placed."
}

variable "environment" {
  description = "The deployment environment (e.g., prod, dev, stage)."
}

module "nat_gateway" {
  source       = "./modules/nat_gateway"
  subnet_id    = "subnet-abcde0123"
  environment  = "prod"
}
```

## ベストプラクティス
- **サブネット戦略**: NATゲートウェイをインターネットゲートウェイにルートがあるパブリックサブネットに配置します。
- **セキュリティ**: 定期的にアクセスを見直し、ルートおよびセキュリティグループ設定を調整して不要なアクセスを制限します。

## 追加情報
NATゲートウェイおよびElastic IPアドレスによって作成されるリソースとその他のオプション設定についての詳細情報は、AWSドキュメントを参照してください。

このモジュールを使用することで、AWS環境でNATゲートウェイを効率的に管理し、展開することができ、プライベートサブネットリソースが必要に応じて安全にインターネットまたはAWSサービスにアクセスできるようになります。