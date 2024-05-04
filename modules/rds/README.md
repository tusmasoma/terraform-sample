# RDS モジュール

## 概要
このTerraformモジュールは、Amazon RDSインスタンスを設定し、管理するために使用されます。このモジュールによって、指定された設定とパラメータに基づいてRDSデータベースインスタンスがプロビジョニングされます。RDSは、スケーラブルでコスト効率の高いリレーショナルデータベースサービスを提供し、管理が簡単で、商用データベースの多くの要求に対応できます。

## 特徴
- **フルマネージドなデータベースサービス**: 自動的なパッチ適用、バックアップ、およびメンテナンスを提供します。
- **マルチAZデプロイメント**: 高可用性のためのマルチAZオプションをサポートします。
- **セキュリティ**: VPC内で動作し、セキュリティグループを通じてアクセス制御を行います。
- **カスタムパラメータグループ**: データベースの動作をカスタマイズするためのパラメータグループをサポートします。

## モジュール入力
- `env`: 環境名（例：prod、dev、staging）。
- `system`: システム識別子。
- `subnets`: RDSインスタンスを配置するサブネットのIDリスト。
- `allocated_storage`: 割り当てられるストレージの量（GB単位）。
- `storage_type`: ストレージのタイプ（例：gp2、io1）。
- `engine`: 使用するデータベースエンジン（例：mysql、postgresql）。
- `engine_version`: データベースエンジンのバージョン。
- `instance_class`: RDSインスタンスのタイプ（例：db.m4.large）。
- `rds_name`: データベースの名前。
- `rds_username`: データベースの管理者ユーザー名。
- `rds_password`: データベースの管理者パスワード。
- `security_group_ids`: RDSインスタンスに関連付けるセキュリティグループIDのリスト。
- `multi_az`: マルチAZデプロイメントを有効にするかどうか。
- `storage_encrypted`: ストレージの暗号化を有効にするかどうか。
- `skip_final_snapshot`: RDSインスタンス削除時に最終スナップショットをスキップするかどうか。

## 使用方法
このモジュールをTerraform設定に含め、必要な入力を提供することで使用します。以下は基本的な例です：

```hcl
module "rds" {
  source              = "../modules/rds"
  env                 = "prod"
  system              = "my-app"
  subnets             = ["subnet-abcdef01", "subnet-abcdef02"]
  allocated_storage   = 20
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = "5.7"
  instance_class      = "db.t2.large"
  rds_name            = "mydatabase"
  rds_username        = "admin"
  rds_password        = "securepassword"
  security_group_ids  = ["sg-0123456789abcdef0"]
  multi_az            = true
  storage_encrypted   = true
  skip_final_snapshot = true
}
```

## 注意点
- **セキュリティ**: 本番環境では、`cidr_blocks` で `"0.0.0.0/0"` を設定する代わりに、より制限的なIP範囲を設定することが推

奨されます。
- **パスワード管理**: パスワードなどの機密情報は、環境変数またはTerraformの秘密管理機能を通じて安全に管理してください。