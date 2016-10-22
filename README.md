# S4
Secure S3

## これはなんですか

[Amazon Simple Storage Service (S3)](https://aws.amazon.com/documentation/s3/) を利用して、複数のユーザ間で、安全にファイルを交換できるシステム構築の自動化です。

## つかいかた

### 管理者

#### 初期設定

* [AWS コマンドラインインターフェイス (CLI)](https://aws.amazon.com/cli/) と [Terraform](https://www.terraform.io/) をインストールする
* AWS アカウントを作成する
* アクセスキーを作成し CLI に設定する
```
$ aws configure --profile s4-foobar
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: ENTER
Default output format [None]: ENTER
$ export AWS_PROFILE=s4-foobar
```
* 管理者のメールアドレスを設定する
```
$ ./verify-email-identity.sh admin@example.com
```
* 管理者のメールアドレスに送信された `Amazon SES Address Verification Request in region US East (N. Virginia)` というメールに書かれた URL をクリックして検証を完了する
* S3 のバケット名を terraform.tfvars ファイルに記述
```
s3_bucket = "foobar"
```
* S3 のバケットへのアクセスを許可する IP アドレスを terraform.tfvars ファイルに記述
```
s3_bucket_source_ip = "203.0.113.0/24"
```
* S3 のバケットにファイルが作成されてから削除されるまでの日数を terraform.tfvars ファイルに記述
```
s3_bucket_expiration_days = "7"
```
* Terraform を適用
```
$ terraform apply
...
Outputs:

aws.account_id = 123456789012
log.bucket = test.log.123456789012
s3.bucket = test.123456789012
```

#### ユーザ作成

* [users.txt](users.txt) ファイルに、利用者のユーザ名とメールアドレスを追記
```
foobar01 alice@example.com
```
* users.tf ファイルを作成
```
$ make
```
* Terraform を適用
```
$ terraform apply
```

### 利用者

#### 初期設定

* 管理者から送信されたメールに従って AWS マネジメントコンソールに `foobar01` でサインイン
```
From: admin@example.com
To: alice@example.com
Subject: https://123456789012.signin.aws.amazon.com/console/iam#users/foobar01 からアクセスキーを作成してください

{
    "UserName": "foobar01",
    "Password": "****************************************",
    "PasswordResetRequired": true
}
```
* パスワードを変更
* アクセスキーを作成

#### S3 にアクセス

##### [Cyberduck](https://cyberduck.io/)

* 環境設定
  * S3
    * Encryption: `SSE-KMS`
* 新規接続
  * `S3（Amazon シンプルストレージサービス）`
  * アクセスキー ID
  * シークレットアクセスキー
  * 詳細設定
    * パス: `test.123456789012`
