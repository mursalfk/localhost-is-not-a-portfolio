# Troubleshooting

The errors you will actually hit, roughly in the order you will hit them.

---

### `403 Forbidden` when opening the S3 website URL

**The one everybody gets.** The files are there; S3 has not been told the public may
read them.

```bash
aws s3api delete-public-access-block --bucket your-unique-site-name
sed 's/BUCKET_NAME/your-unique-site-name/' policies/bucket-policy.json > /tmp/policy.json
aws s3api put-bucket-policy --bucket your-unique-site-name --policy file:///tmp/policy.json
```

---

### `BucketAlreadyExists`

Bucket names are globally unique across every AWS account on earth. `portfolio` was
taken in 2007. Add your name and some digits.

---

### `404 Not Found` on the S3 website URL

Either `index.html` is not at the root of the bucket, or static website hosting was
never enabled.

```bash
aws s3 ls s3://your-unique-site-name
aws s3 website s3://your-unique-site-name --index-document index.html --error-document index.html
```

If your build output went into a subfolder, sync the *contents*: `aws s3 sync dist/ s3://...`,
not `aws s3 sync . s3://...`.

---

### Routes work locally, 404 in production

Single-page app. The server looks for `/about/index.html`, which does not exist.
Set the error document to `index.html` so the app's router handles it (above).

---

### `Unable to locate credentials`

```bash
aws configure
aws sts get-caller-identity
```

If `get-caller-identity` fails, the keys are wrong or were deactivated. Make new ones
in IAM.

---

### `AccessDenied` on almost anything

Your IAM user lacks the permission. For a practice account, attach `AmazonS3FullAccess`
and `CloudFrontFullAccess`. In real work you would scope these down to the one bucket.

---

### `An error occurred (ExpiredToken)`

Temporary credentials timed out. Refresh them, or `aws configure` again with long-lived
keys for now.

---

### CloudFront still shows the old version

The cache is doing its job. Either wait, or invalidate:

```bash
aws cloudfront create-invalidation --distribution-id EXXXXXXXXXXXXX --paths "/*"
```

First 1,000 invalidation paths a month are free. After that they cost money, which is
why real deployments use hashed filenames instead of invalidating everything.

---

### CloudFront distribution stuck "In Progress"

Normal. 5–15 minutes. Go get chai.

---

### CloudFront returns XML instead of my site

You pointed the distribution at the bucket's *REST* endpoint
(`bucket.s3.amazonaws.com`) rather than the *website* endpoint
(`bucket.s3-website-region.amazonaws.com`). `scripts/create-distribution.sh` uses the
right one.

---

### GitHub Action fails: `Could not assume role`

OIDC trust policy mismatch. The `sub` condition must match your repo exactly:

```
repo:YOUR_GITHUB_USERNAME/YOUR_REPO:ref:refs/heads/main
```

Check `policies/github-oidc-trust.json`, and confirm the job has:

```yaml
permissions:
  id-token: write
  contents: read
```

Missing `id-token: write` is the usual cause.

---

### GitHub Action fails: `AccessDenied` on s3:PutObject

The role assumed fine, but its permission policy does not cover your bucket. Check the
bucket name in the role's policy matches the real one.

---

### I think I am being charged

```bash
aws ce get-cost-and-usage \
  --time-period Start=$(date -u -d '1 month ago' +%Y-%m-01),End=$(date -u +%Y-%m-%d) \
  --granularity MONTHLY --metrics UnblendedCost
```

Then open **Billing → Cost Explorer** in the console and look at what is actually
running. Usual culprits: a NAT Gateway, an RDS instance, an idle EC2 box, or old EBS
snapshots. Nothing in this repo creates any of those.

Tear down everything this repo created:

```bash
bash scripts/teardown.sh your-unique-site-name
```

---

### Still stuck

Open an issue on this repo, or find me: [@mursal.dev](https://instagram.com/mursal.dev) ·
[dev.to/mursalfk](https://dev.to/mursalfk)
