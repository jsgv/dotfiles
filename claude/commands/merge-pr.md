---
description: Squash merge the current branch's PR into main after CI passes, then clean up
allowed-tools: Bash
---

# Merge PR

Squash merge the current branch's green PR into main, pull latest, and prune stale local branches.

## Steps

### 1. Verify we are on a feature branch with a PR

```bash
git branch --show-current
```

- If on `main`, **stop and tell the user** — this command only works from a feature branch.
- Check for an open PR on this branch:

```bash
gh pr view --json number,title,url,state
```

- If no PR exists or the PR is not open, **stop and tell the user**.

### 2. Verify no uncommitted or unpushed changes

Check for uncommitted changes:

```bash
git status --porcelain
```

- If there are any uncommitted changes (staged or unstaged), **stop and tell the user** to commit or stash them first. Do not proceed.

Check for unpushed commits:

```bash
git log @{u}..HEAD --oneline
```

- If there are any unpushed commits, **stop and tell the user** to push them first. Do not proceed — unpushed commits will be lost in the squash merge.

### 3. Verify CI is green

Check that all CI status checks have passed:

```bash
gh pr checks
```

- **If there are no CI checks configured**, treat this as OK and proceed.
- **If checks exist, every check must show a pass status.** If any check is pending or failing, **stop and tell the user** which checks are not passing. Do not proceed.

### 4. Squash merge the PR

```bash
gh pr merge --squash --delete-branch
```

This squash merges the PR into the base branch and deletes the remote feature branch.

### 5. Switch to main and pull

```bash
git checkout main
git pull origin main
git fetch --all --prune
```

### 6. Clean up local branches

Remove any local branches whose remote tracking branch no longer exists:

```bash
git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -r git branch -D
```

### 7. Confirm

Print a short summary:
- The PR that was merged (number, title, URL)
- Current branch (`main`)
- Any local branches that were cleaned up

## Important

- **Never merge with uncommitted changes or unpushed commits** — these will be lost in the squash merge. Always check and report before proceeding.
- **Never merge if CI is not fully green** — always check and report failures
- **Never run from main** — the command requires being on a feature branch with a PR
- **Never force anything** — if the merge fails, report the error to the user
