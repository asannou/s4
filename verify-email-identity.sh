#!/bin/sh

set -ex

REGION='us-east-1'
ADMIN='admin.txt'

FROM="$1"

ACCOUNT_ID=$(aws sts get-caller-identity | grep '"Account"' | cut -d '"' -f 4)
aws --region "$REGION" ses verify-email-identity --email-address "$FROM"

echo "$ACCOUNT_ID $FROM" > "$ADMIN"
