---
description: Stage all changes, commit, push, and open a pull request
allowed-tools: Bash, Read, Glob
---

# Git Sync

Stage **all** current changes (not just the most recent work — everything in the working tree), commit, push, and open a pull request.

## Steps

### 1. Check current state

```bash
git status
git branch --show-current
```

#### Detect Jira ticket

Check for a Jira ticket ID (e.g., `ABC-123`) using the following sources, in priority order:

1. **`$ARGUMENTS`** — if the argument matches a Jira ticket pattern (`[A-Z]+-\d+`), extract it
2. **Branch name** — if the current branch contains a Jira ticket pattern (e.g., `feat/ABC-123-add-auth`), extract it

If a Jira ticket is found, store it for use in the commit message and PR title (see steps 3 and 5).

### 2. Create branch if needed

If on `main` branch:
- If argument provided (`$ARGUMENTS`) **and it is NOT a Jira ticket pattern**, use it as the branch name
- Otherwise, analyze the staged/unstaged changes and generate an appropriate branch name:
  - Use format: `<type>/<short-description>` (e.g., `feat/add-user-auth`, `fix/login-redirect`, `docs/update-readme`)
  - If a Jira ticket was detected, include it in the branch name (e.g., `feat/ABC-123-add-user-auth`)
  - Keep it lowercase with hyphens, no spaces
  - Make it descriptive but concise (2-4 words after the type)
- Check if branch already exists: `git branch --list <branch-name>`
- If branch doesn't exist, create and switch to it: `git checkout -b <branch-name>`
- If branch exists, switch to it: `git checkout <branch-name>`

If already on a feature branch, continue with that branch.

### 3. Stage and commit ALL changes

**Important**: Stage everything in the working tree — all new, modified, and deleted files. The commit should represent the full set of current changes, not just the most recent work.

```bash
git add -A
git status
git diff --cached
```

Review **all** the staged changes (the full diff, not just recent edits) and create a commit message following conventional commits format.

The commit message should:
- Use conventional commit format (feat:, fix:, docs:, refactor:, etc.)
- **If a Jira ticket was detected**, prefix the commit message with the ticket ID: `ABC-123: <type>: <description>`
- Be concise but descriptive
- Reflect the totality of the changes, not just the last thing worked on
- End with a `Co-Authored-By` trailer using the name and email of the AI tool executing this command (e.g., `Co-Authored-By: Claude <noreply@anthropic.com>`, `Co-Authored-By: OpenCode <noreply@opencode.ai>`, etc.)

```bash
# With Jira ticket:
git commit -m "$(cat <<'EOF'
ABC-123: <type>: <description>

Co-Authored-By: TOOL_NAME <TOOL_EMAIL>
EOF
)"

# Without Jira ticket:
git commit -m "$(cat <<'EOF'
<type>: <description>

Co-Authored-By: TOOL_NAME <TOOL_EMAIL>
EOF
)"
```

### 4. Push to remote

```bash
git push -u origin <branch-name>
```

### 5. Create or reuse Pull Request

**Before creating or updating the PR, re-read this file (`~/.claude/commands/git-sync.md`) to ensure you have the exact PR template — do not rely on memory or default templates.**

First, check if a PR already exists for the current branch:

```bash
gh pr view --json url,title 2>/dev/null
```

- **If a PR already exists**: Do NOT create a new one. The push in step 4 already updated it. Just note the existing PR URL.
- **If no PR exists**: Create one using the `gh` CLI:

If a Jira ticket was detected, prefix the PR title the same way as the commit message (e.g., `ABC-123: feat: add user auth`).

```bash
gh pr create --title "<commit-title>" --body "$(cat <<'EOF'
## Why

[Explain the motivation and reasoning behind these changes. What problem does this solve? Why is this approach the right one? Focus on the context and rationale, not the implementation details.]

## Summary

[Brief bullet points summarizing the key changes - only include if there are notable implementation details worth highlighting]

---
🤖 Generated with [TOOL_NAME](TOOL_URL)
EOF
)"
```

> **Tool attribution:** Identify which AI coding tool is executing this command (e.g., Claude Code, OpenCode, Cursor, Windsurf, Copilot, etc.) and substitute `TOOL_NAME` and `TOOL_URL` in the footer above with the correct name and URL. Use this same tool name consistently in the commit trailer and PR footer.

### 6. Review and update PR title and description

Whether the PR is new or existing, review the current PR title and body against the **full diff** on the branch (`git diff main...HEAD`). If the title or description no longer accurately reflects the overall changes (e.g., scope has grown, focus has shifted), update them:

```bash
gh pr edit --title "<updated-title>" --body "$(cat <<'EOF'
<updated body>
EOF
)"
```

Only skip this if the existing title and description already accurately represent the full set of changes. When updating the body, always preserve the `🤖 Generated with ...` footer with the correct tool attribution.

### 7. Return the PR URL

After creating or updating the PR, display the URL so the user can review it.

## Important

- **Commit ALL changes**: Always use `git add -A` and review the full diff — the commit should capture everything in the working tree, not just the latest edits
- **Focus on WHY**: The PR description should emphasize the reasoning and motivation, not just list what changed
- **Summary section is optional**: Only include if there are notable implementation details worth highlighting; the diff already shows what changed
- **Conventional commits**: Always use conventional commit format
- **Don't force push**: Never use `--force` unless explicitly asked
