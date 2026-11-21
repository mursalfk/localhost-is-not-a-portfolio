# Setup — do this before you try it

Five minutes. Do it at home, on wifi you trust.

---

## 1. Node.js

```bash
node --version    # want v18 or newer
```

Nothing? Install the LTS build from [nodejs.org](https://nodejs.org).

---

## 2. An AWS account

Sign up at [aws.amazon.com/free](https://aws.amazon.com/free). It needs a card for
verification. **It will not charge you for anything in this guide** — everything here sits
inside the free tier, and step 05 sets an alert anyway.

Students: check [AWS Academy](https://aws.amazon.com/training/awsacademy/) or
[AWS Educate](https://aws.amazon.com/education/awseducate/) first — your university may
already give you credits.

---

## 3. The AWS CLI

```bash
aws --version     # want v2
```

If not: [install guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

**macOS**
```bash
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

**Windows** — download and run the MSI from the link above.

**Linux**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install
```

---

## 4. Connect the CLI to your account

In the AWS console: **IAM → Users → your user → Security credentials → Create access key**.
Choose *Command Line Interface*. Copy both values — the secret is shown **once**.

```bash
aws configure
```

```
AWS Access Key ID     : AKIA...
AWS Secret Access Key : ...
Default region name   : ap-south-1
Default output format : json
```

`ap-south-1` is Mumbai, the nearest region to Karachi. Any region works.

> Never commit these keys. Never paste them in a chat, a screenshot, or a slide.
> In chapter IV we replace them with OIDC roles for exactly this reason.

---

## 5. Prove it works

```bash
aws sts get-caller-identity
```

You should get back your account number and user ARN. If you do, you are ready.

---

## 6. Bring a project

Any frontend project that produces a `dist/` or `build/` folder — React, Vue, Svelte,
Astro, plain HTML. The uglier the better.

No project? `demo-app/` in this repo works:

```bash
cd demo-app && npm install && npm run build
```

---

## If something fails

[TROUBLESHOOTING.md](TROUBLESHOOTING.md) covers the usual suspects. Still stuck? Open an
issue on this repo and paste the exact error text.
