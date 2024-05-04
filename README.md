# terraform-sample
## Description
このプロジェクトはTerraformを使用してAWSリソースを管理します。プロジェクト内で定義されている主なリソースにはVPC、EC2インスタンス、ロードバランサーなどが含まれます。環境は stage と prod に分けて管理されており、それぞれの環境で異なる設定を適用することが可能です。

## Prerequisites
プロジェクトを実行する前に、以下のツールがインストールされている必要があります：
- Terraform (推奨バージョン: 0.12.x 以上)
- AWS CLI
- 適切なAWS認証情報（AWSアクセスキーIDとシークレットアクセスキー）

## Setup
1. AWS CLIに認証情報を設定する:
    ```bash
    aws configure
    ```
   このコマンドに従って、AWSアクセスキーID、シークレットアクセスキー、リージョン、出力形式を設定します。

2. リポジトリをクローンし、プロジェクトディレクトリに移動します:
    ```bash
    git clone https://your-repository-url.git
    cd your-repository-directory
    ```

3. Terraformを初期化します:
    ```bash
    cd prd # 環境ごとに初期化
    terraform init
    ```

## Common Commands
- **Terraform Plan**:
    ```bash
    terraform plan
    ```
   このコマンドは、実行される変更を表示します。

- **Terraform Apply**:
    ```bash
    terraform apply
    ```
   `terraform plan`で生成された計画に基づいてリソースを適用します。実行確認が求められるため、プロンプトに `yes` と入力する必要があります。

- **Terraform Destroy**:
    ```bash
    terraform destroy
    ```
   管理下の全リソースを安全に破棄します。このコマンドも実行前に確認が求められます。
