# Language

Match the user's language: reply in English when they write in English, reply in Simplified Chinese (简体中文) when they write in Simplified Chinese. Internal reasoning must stay in the same language as the reply (or English) — never drift into Japanese, Korean, Traditional Chinese, or other languages.

# pnpm projects

If the repo is pnpm-managed (has `pnpm-lock.yaml`, or `packageManager: "pnpm@..."` in `package.json`), prefer `pnpm dlx <pkg>` over `npx <pkg>` for one-off package execution.

# Kong PRs — Jira ticket workflow

When opening a PR in a Kong repo (git remote matches `github.com[:/]Kong/` or `konghq`), the PR body must include the Jira ticket on its own line, in square brackets, right after the title, e.g. `[KM-2000]`.

Do not extract the ticket ID from the branch name — Kong branch names do not carry ticket IDs.

If the user didn't supply a ticket, use the Atlassian Rovo MCP (`mcp__claude_ai_Atlassian_Rovo__*`) — see memory `jira_kong_reference.md` for cloudId, accountId, transition IDs:

1. **Reuse** — search for an existing in-progress ticket assigned to the user with `searchJiraIssuesUsingJql`, JQL: `assignee = currentUser() AND statusCategory = "In Progress" AND project = KM` (adjust project if the PR is in a different Kong area). If a result matches the PR's intent, confirm via AskUserQuestion before using.
2. **Create** — if none fits:
   - Draft a `summary` from the PR title/changes and **always** confirm via AskUserQuestion before creating (auto-generated titles are often inaccurate).
   - `createJiraIssue` in the right project (default `KM`), assignee = user's accountId, issuetype `Task` unless context clearly indicates Bug/Story.
   - Add to the active sprint: find the sprint id via `searchJiraIssuesUsingJql` with `project = KM AND sprint in openSprints()` requesting the sprint custom field, then `editJiraIssue` to set it on the new issue.
   - `transitionJiraIssue` to "In Progress" (KM transition id `21`; for other projects fetch via `getTransitionsForJiraIssue`).
3. **Write** the resulting ticket key into the PR body before opening.

# Kong repos — local checkout location

Kong repositories (git remote matches `github.com[:/]Kong/` or `konghq`) are typically cloned under `C:\Repositories\`. When the user references another Kong repo for cross-repo code reading, look there first (e.g. `C:\Repositories\<repo-name>`) before cloning or asking.
