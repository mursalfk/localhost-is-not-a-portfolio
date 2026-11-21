#!/usr/bin/env bash
# Build, upload, and bust the cache. One command.
#   usage: bash scripts/deploy.sh my-bucket-name [DISTRIBUTION_ID]
set -euo pipefail

BUCKET="${1:?usage: deploy.sh <bucket-name> [distribution-id]}"
DIST_ID="${2:-}"

echo "==> building"
npm run build

echo "==> uploading to s3://$BUCKET"
aws s3 sync dist/ "s3://$BUCKET" --delete

if [ -n "$DIST_ID" ]; then
  echo "==> invalidating CloudFront cache"
  aws cloudfront create-invalidation --distribution-id "$DIST_ID" --paths "/*" >/dev/null
fi

echo "==> done"
