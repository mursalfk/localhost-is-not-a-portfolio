#!/usr/bin/env bash
# Delete everything this repo created.
#   usage: bash scripts/teardown.sh my-bucket-name
set -euo pipefail

BUCKET="${1:?usage: teardown.sh <bucket-name>}"

read -r -p "Delete s3://${BUCKET} and everything in it? [y/N] " ok
[ "$ok" = "y" ] || { echo "cancelled"; exit 0; }

aws s3 rm "s3://$BUCKET" --recursive
aws s3 rb "s3://$BUCKET"
echo "==> bucket gone"

echo
echo "CloudFront must be disabled before it can be deleted, and that takes a few"
echo "minutes. List your distributions with:"
echo
echo "    aws cloudfront list-distributions --query \"DistributionList.Items[].{Id:Id,Domain:DomainName}\""
echo
echo "then disable and delete it in the console. A disabled distribution costs nothing."
