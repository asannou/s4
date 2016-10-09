provider "aws" {
  region = "${var.aws_region}"
}

data "aws_caller_identity" "aws" {}

resource "aws_s3_bucket" "s3" {
  bucket = "${var.s3_bucket}.${data.aws_caller_identity.aws.account_id}"
  acl = "private"
  policy = "${template_file.bucket_policy.rendered}"
  lifecycle_rule {
    enabled = true
    prefix = "/"
    expiration {
      days = "${var.s3_bucket_expiration_days}"
    }
  }
  logging {
    target_bucket = "${aws_s3_bucket.log.id}"
    target_prefix = "logs/"
  }
  tags {
    Name = "s4"
  }
}

resource "aws_s3_bucket" "log" {
  bucket = "${var.s3_bucket}.log.${data.aws_caller_identity.aws.account_id}"
  acl = "log-delivery-write"
  tags {
    Name = "s4"
  }
}

resource "template_file" "bucket_policy" {
  template = "${file("bucket_policy.json")}"
  vars {
    bucket = "${var.s3_bucket}.${data.aws_caller_identity.aws.account_id}"
  }
}

resource "aws_iam_group" "group" {
  name = "s4.${var.s3_bucket}"
}

resource "aws_iam_group_policy" "group_policy" {
  name = "s4.${var.s3_bucket}"
  group = "${aws_iam_group.group.id}"
  policy = "${template_file.group_policy.rendered}"
}

resource "template_file" "group_policy" {
  template = "${file("group_policy.json")}"
  vars {
    bucket = "${aws_s3_bucket.s3.bucket}"
    source_ip = "${var.s3_bucket_source_ip}"
  }
}

