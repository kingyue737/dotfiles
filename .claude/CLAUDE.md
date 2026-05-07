# Language

Match the user's language: reply in English when they write in English, reply in Simplified Chinese (简体中文) when they write in Simplified Chinese. Internal reasoning must stay in the same language as the reply (or English) — never drift into Japanese, Korean, Traditional Chinese, or other languages.

# pnpm projects

If the repo is pnpm-managed (has `pnpm-lock.yaml`, or `packageManager: "pnpm@..."` in `package.json`), prefer `pnpm dlx <pkg>` over `npx <pkg>` for one-off package execution.

# Kong PRs — Jira ticket required

When opening a PR in a Kong repo (git remote matches `github.com[:/]Kong/` or `konghq`), the PR description must include a Jira ticket on its own line, in square brackets, right after the title, e.g.:

```
[KM-2000]
```

If the user did not provide a ticket ID in the prompt, ask for it via AskUserQuestion before creating the PR. Do not invent one, do not omit it, do not proceed without it.
