#!/bin/sh

USERNAME="$1"

aws iam delete-login-profile --user-name "$USERNAME"
aws iam list-access-keys --user-name "$USERNAME" | grep '"AccessKeyId"' | cut -d '"' -f 4 | xargs -n 1 aws iam delete-access-key --user-name "$USERNAME" --access-key-id
