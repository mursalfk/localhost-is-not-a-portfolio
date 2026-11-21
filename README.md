# localhost is not a portfolio

Everything from my talk at **AWS Student Builders Day Karachi**, so you can try it yourself afterwards.

You have a project that only runs on your laptop. By the end of this, it has a URL
that anyone in the world can open, it redeploys itself when you push a commit, and
it costs you nothing.

Given by [Mursal Furqan Kumbhar](https://mursalfk.vercel.app) — AWS Community Builder, ML/AI.

---

## Start here

1. **[SETUP.md](SETUP.md)** — do this first, at home. Five minutes.
2. **[CHEATSHEET.md](CHEATSHEET.md)** — every command from the talk, in order.
3. **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** — the errors you will hit, and the fixes.

No project handy? Use `demo-app/`. It is deliberately ugly, so there is nothing to be precious about.

---

## What we build

```
your project  ──build──>  dist/  ──sync──>  Amazon S3  ──>  CloudFront  ──>  a real URL
                                                 ▲
                                    GitHub Actions does this
                                    every time you push
```

| Piece | What it actually does |
|---|---|
| **Amazon S3** | A folder the internet can read. It holds your built files. |
| **Amazon CloudFront** | That folder, copied into 400+ cities, served over HTTPS. |
| **GitHub Actions** | Runs the build and the upload for you on every push. |
| **AWS Budgets** | Emails you the moment spending crosses $1. Non-negotiable. |

---

## The five steps

```bash
# 01 — build
npm install && npm run build

# 02 — make the bucket  (names are global: pick something unique)
aws s3 mb s3://your-unique-site-name

# 03 — upload
aws s3 sync dist/ s3://your-unique-site-name --delete
#    → you will get a 403 when you open it. That is expected. See TROUBLESHOOTING.md

# 04 — put CloudFront in front of it
bash scripts/create-distribution.sh your-unique-site-name

# 05 — guard your wallet, before you close the laptop
bash scripts/budget-alarm.sh you@example.com
```

Then automate it: [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml).

---

## Cost

Everything here sits inside the AWS Free Tier for a small site. Expect **$0**.

What actually bites students is not this stack — it is a NAT Gateway billed by the
hour, an RDS instance left running, or old EBS snapshots. We do not create any of those.

Still: **set the budget alert in step 05.** Every time. Even for a toy.

When you are done experimenting:

```bash
bash scripts/teardown.sh your-unique-site-name
```

---

## Your challenge

Open the folder you have not opened since the semester ended. Run the five steps.
Post your live URL in the event WhatsApp group, and tag me — I will reply to every one.

A project nobody can open is a project that does not exist yet.

---

## Keep going

- [S3 static website hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [CloudFront developer guide](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/GettingStarted.html)
- [AWS Free Tier](https://aws.amazon.com/free/) · [AWS Budgets](https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-managing-costs.html)
- [OpenID Connect in AWS, GitHub Docs](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
- [AWS Skill Builder](https://skillbuilder.aws/) · [AWS Builder Center](https://builder.aws.com/)

## Find me

[mursalfk.vercel.app](https://mursalfk.vercel.app) · [dev.to/mursalfk](https://dev.to/mursalfk) · [github.com/mursalfk](https://github.com/mursalfk) · [@mursal.dev](https://instagram.com/mursal.dev)

MIT licensed. Take it, fork it, teach it to someone else.
