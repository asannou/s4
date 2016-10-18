#!/bin/sh

set -ex

REGION='us-east-1'
ADMIN='admin.txt'

FROM="$1"

aws --region "$REGION" ses verify-email-identity --email-address "$FROM"
echo "$FROM" > "$ADMIN"
