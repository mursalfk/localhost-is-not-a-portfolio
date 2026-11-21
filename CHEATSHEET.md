# Cheatsheet

Every command from the talk, in order. Replace `your-unique-site-name` throughout —
bucket names are globally unique across all of AWS, so add your name or a number.

---

## 01 · Build

```bash
npm install
npm run build        # produces dist/
ls dist/             # sanity check: index.html should be in there
```

## 02 · Make the bucket

```bash
aws s3 mb s3://your-unique-site-name --region ap-south-1
```

Turn on static website hosting:

```bash
aws s3 website s3://your-unique-site-name \
  --index-document index.html \
  --error-document index.html
```

> `--error-document index.html` matters for React Router and friends. Without it,
> every route except `/` returns a 404.

## 03 · Upload

```bash
aws s3 sync dist/ s3://your-unique-site-name --delete
```

Open it:

```
http://your-unique-site-name.s3-website.ap-south-1.amazonaws.com
```

**You will get 403 Forbidden.** Good. That is S3 being secure by default.

Allow the public to read:

```bash
aws s3api delete-public-access-block --bucket your-unique-site-name

sed 's/BUCKET_NAME/your-unique-site-name/' policies/bucket-policy.json > /tmp/policy.json
aws s3api put-bucket-policy --bucket your-unique-site-name --policy file:///tmp/policy.json
```

Refresh. Your site is on the internet.

## 04 · CloudFront, for HTTPS and speed

```bash
bash scripts/create-distribution.sh your-unique-site-name
```

Takes 5–15 minutes to deploy. The script prints your `d1234abcd.cloudfront.net` domain.

Changed a file and still see the old one? That is the cache. Invalidate it:

```bash
aws cloudfront create-invalidation --distribution-id EXXXXXXXXXXXXX --paths "/*"
```

## 05 · Guard your wallet

```bash
bash scripts/budget-alarm.sh you@example.com
```

A $1 monthly budget with an email alert at 80%. Do this before you close the laptop.

---

## Automate it

```bash
bash scripts/deploy.sh your-unique-site-name     # build + sync + invalidate, in one
```

Then move it into CI — see [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml)
and the OIDC section in [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

---

## Tear it down

```bash
bash scripts/teardown.sh your-unique-site-name
```

---

## Useful checks

```bash
aws sts get-caller-identity                      # who am I
aws s3 ls                                        # my buckets
aws s3 ls s3://your-unique-site-name --human-readable
aws cloudfront list-distributions --query "DistributionList.Items[].{Id:Id,Domain:DomainName}"
aws budgets describe-budgets --account-id $(aws sts get-caller-identity --query Account --output text)
```
