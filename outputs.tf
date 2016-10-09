output "aws.account_id" {
  value = "${data.aws_caller_identity.aws.account_id}"
}

output "s3.bucket" {
  value = "${aws_s3_bucket.s3.bucket}"
}

output "log.bucket" {
  value = "${aws_s3_bucket.log.bucket}"
}

