#!/bin/sh

set -ex

REGION='us-east-1'
ADMIN='admin.txt'
USERS='users.txt'

USERNAME="$1"

NUM=$(cut -d ' ' -f 1 "$USERS" | grep -n -Fx "$USERNAME" | cut -d : -f 1)

test -z "$NUM" && exit 1

ACCOUNT_ID=$(cat "$ADMIN" | cut -d ' ' -f 1)
SUBJECT="=?UTF-8?B?$(echo "https://$ACCOUNT_ID.signin.aws.amazon.com/console/iam#users/$USERNAME からアクセスキーを作成してください" | base64)?="
FROM=$(cat "$ADMIN" | cut -d ' ' -f 2)
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
