#!/usr/bin/env bash
# Put CloudFront in front of an S3 website bucket.
#   usage: bash scripts/create-distribution.sh my-bucket-name
set -euo pipefail

BUCKET="${1:?usage: create-distribution.sh <bucket-name>}"
REGION="$(aws configure get region)"
REGION="${REGION:-ap-south-1}"
ORIGIN="${BUCKET}.s3-website.${REGION}.amazonaws.com"
REF="site-$(date +%s)"

cat > /tmp/dist-config.json <<JSON
{
  "CallerReference": "${REF}",
  "Comment": "localhost is not a portfolio — ${BUCKET}",
  "Enabled": true,
  "DefaultRootObject": "index.html",
  "Origins": {
    "Quantity": 1,
    "Items": [{
      "Id": "s3-website",
      "DomainName": "${ORIGIN}",
      "CustomOriginConfig": {
        "HTTPPort": 80,
        "HTTPSPort": 443,
        "OriginProtocolPolicy": "http-only"
      }
    }]
  },
  "DefaultCacheBehavior": {
    "TargetOriginId": "s3-website",
    "ViewerProtocolPolicy": "redirect-to-https",
    "AllowedMethods": { "Quantity": 2, "Items": ["GET", "HEAD"] },
    "Compress": true,
    "CachePolicyId": "658327ea-f89d-4fab-a63d-7e88639e58f6"
  },
  "PriceClass": "PriceClass_100"
}
JSON

echo "==> creating distribution for ${ORIGIN}"
OUT="$(aws cloudfront create-distribution --distribution-config file:///tmp/dist-config.json)"

ID="$(echo "$OUT"  | python3 -c 'import sys,json; print(json.load(sys.stdin)["Distribution"]["Id"])')"
DOM="$(echo "$OUT" | python3 -c 'import sys,json; print(json.load(sys.stdin)["Distribution"]["DomainName"])')"

echo
echo "    distribution id : ${ID}"
echo "    your URL        : https://${DOM}"
echo
echo "    Status will be 'InProgress' for 5-15 minutes. That is normal."
