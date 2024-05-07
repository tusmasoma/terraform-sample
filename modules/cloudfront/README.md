# CloudFront モジュール

この Terraform モジュールは、AWS CloudFront 配信を設定して、S3 バケットから静的コンテンツを提供するように構成します。この設定は AWS のコンテンツ配信ネットワークを利用してセキュリティとパフォーマンスを向上させます。

## 特徴

- **S3 オリジン**: Amazon S3 バケットを CloudFront 配信のオリジンとして設定します。これは静的ウェブサイトをホスティングするのに理想的です。
- **HTTPS リダイレクト**: HTTP リクエストを HTTPS に自動的にリダイレクトし、セキュリティと SEO を向上させます。
- **地理的制限**: 地理的な位置に基づいてコンテンツへのアクセスを制限するためにホワイトリストを使用します。デフォルトでは、日本からのリクエストのみが許可されます。
- **キャッシング動作**: GET および HEAD メソッドのキャッシングポリシーを定義して配信を最適化します。これにより、オリジンサーバーへの負荷と遅延が最小限に抑えられます。

## 使用方法

このモジュールを使用するには、必要な変数（`bucket_name` と `bucket_region`）が定義されていることを確認してください。適切なパラメータを使用して Terraform 設定にこのモジュールを含めます：

```hcl
module "cloudfront" {
  source        = "path/to/module/cloudfront"
  bucket_name   = "your-bucket-name"
  bucket_region = "your-bucket-region"
}
```

## 作成されるリソース

- **aws_cloudfront_distribution.static-www**: 最適なキャッシュとセキュリティ設定で指定された S3 バケットからコンテンツを提供するように構成された CloudFront 配信。
- **aws_cloudfront_origin_access_identity.static-www**: CloudFront が S3 バケット内のコンテンツに安全にアクセスできるようにするオリジンアクセスアイデンティティ。

## パラメータ

- **var.bucket_name**: CloudFront 配信のオリジンとして機能する S3 バケットの名前。
- **var.bucket_region**: S3 バケットが位置する AWS リージョン。

## セキュリティとパフォーマンスの設定

- **SSL/TLS**: CloudFront のデフォルト SSL/TLS 証明書を使用して HTTPS を利用します。
- **キャッシングポリシー**: 最適化されたキャッシングのために異なる TTL 設定を構成します。
- **地理的制限**: コンテンツへのアクセスを地理的な位置に基づいて制限するためにホワイトリストを使用します。

詳細な使用法とカスタマイズについては、モジュール内の変数定義とリソース設定を参照してください。
