variable "aws_region" {
  default = "ap-northeast-1"
}

variable "s3_bucket" {}

variable "s3_bucket_source_ip" {
  default = "0.0.0.0/0"
}

variable "s3_bucket_expiration_days" {
  default = "10"
}

