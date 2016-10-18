#!/bin/sh

index=1

while read line
do
  echo "$line" | grep -q '^\s*#' && continue
  user=$(echo "$line" | cut -d ' ' -f 1)
  users="${users}\"\${aws_iam_user.$index.name}\", "
  cat <<EOD
resource "aws_iam_user" "$index" {
  name = "$user"
  provisioner "local-exec" {
    command = "./create-login-profile.sh '$user'"
  }
}

resource "aws_iam_user_policy_attachment" "$index" {
  user = "\${aws_iam_user.$index.name}"
  policy_arn = "\${aws_iam_policy.user_policy.arn}"
}

EOD
  index=$(expr $index + 1)
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

