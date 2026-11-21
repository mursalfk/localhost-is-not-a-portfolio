# demo-app

A deliberately ugly one-page site, for anyone who turned up without a project.

```bash
npm install
npm run build     # -> dist/
```

It stamps its own build time on the page, so when you push a commit and the
GitHub Action redeploys, you can watch the timestamp change. That is the proof
that the pipeline works.
