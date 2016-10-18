#!/bin/sh

set -ex

REGION='us-east-1'
USERS='users.txt'

ACCOUNT_ID="$1"
USERNAME="$2"

NUM=$(cut -d ' ' -f 1 "$USERS" | grep -n -Fx "$USERNAME" | cut -d : -f 1)

test -z "$NUM" && exit 1

SUBJECT="=?UTF-8?B?$(echo "https://$ACCOUNT_ID.signin.aws.amazon.com/console から IAM ユーザでログインしてください" | base64)?="
FROM=$(cat admin.txt)
TO=$(sed -n ${NUM}p "$USERS" | cut -d ' ' -f 2)
PROFILE="$USERNAME.login-profile.json"

PASSWORD=$(./password.py)

cat <<EOD > $PROFILE
{
    "UserName": "$USERNAME",
    "Password": "$PASSWORD",
    "PasswordResetRequired": true
}
EOD

aws iam delete-login-profile --user-name "$USERNAME" || true
aws iam create-login-profile --cli-input-json "file://$PROFILE"
aws --region "$REGION" ses send-email --from "$FROM" --to "$TO" --subject "$SUBJECT" --text "file://$PROFILE"

rm $PROFILE
