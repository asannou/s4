#!/bin/sh

while read name
do
  user=$(echo "$name" | tr -c '[:alnum:]_-\n' '_')
  users="${users}\"$name\", "
  cat <<EOD
resource "aws_iam_user" "$user" {
  name = "$name"
  provisioner "local-exec" {
    command = "echo done '$name'"
  }
}

EOD
done

cat <<EOD
resource "aws_iam_group_membership" "group_membership" {
  name = "s4.\${var.s3_bucket}"
  group = "\${aws_iam_group.group.name}"
  users = [
    $users
  ]
}
EOD

