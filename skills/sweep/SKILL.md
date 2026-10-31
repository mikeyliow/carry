---
name: sweep
description: Owner-run cleanup of one repo's codebase. Finds PII and secrets, code comments, tests that pin business logic, and files that should never have been committed or left lying around, then shows one grouped report. Changes nothing until the owner picks what goes; applies the picks on a branch, one commit per group, and never pushes. Use only for /carry:sweep.
disable-model-invocation: true
---

# Sweep

**Find everything that does not belong in a carry codebase, show it grouped, and remove only what the owner picks.** Codebase only: worktrees, branches and sandboxes are `carry tidy`.

```
1. find (read-only) ──► 2. report ──► 3. owner picks ──► 4. apply on a branch ──► 5. check, reply
```

`/carry:sweep` sweeps the repo this session is in. `/carry:sweep <path>` narrows it to a folder.

## 1. Find (read-only)

Run the four hunts in parallel with `checker` agents. Each returns `file:line`, what it found, and a proposed action. Skip what the repo's `.carry/rules.md` lists under "Do not touch", plus generated, vendored and lock files, `.git/` and `.carry/`.

| Hunt | Look for | Proposed action |
|---|---|---|
| **PII and secrets** | real emails, phone numbers, names, addresses, IDs; API keys, tokens, private keys, connection strings; customer data in fixtures, seeds and test data | replace with obvious fakes (`user@example.com`), or delete the file |
| **Comments** | every code comment except tool directives (lint and type ignores, build tags, shebangs, encoding lines) and license headers the license requires | delete |
| **Tests that pin business logic** | tests that assert a product choice the spec owns: copy text, prices, thresholds, tier rules, UI snapshots; tests of private internals or mocks of the code under test | delete |
| **Bad files** | tracked or untracked-but-not-ignored: `.env*` with values, dumps, `*.sqlite`, logs, HAR files, screenshots, coverage and build output, editor and OS files, scratch scripts and notes left for local convenience | ignore and untrack, or move out |

Keep these tests: ones that check a contract (API shape, status codes), an invariant (auth, money adds up, no data loss), or a bug fix whose risk is still live. They are what lets the code change safely.

Also check git history for secrets: `git log -p -S` on each secret pattern found. Report only.

## 2. Report

One message, grouped. Per group: the count, a table (`file:line`, what, action), and the risk of removing it.

```
Sweep · api · 4 groups

PII & secrets   3   ⚠ 1 secret also in history: rotate it
Comments       41
Tests           6   all pin pricing copy or snapshots
Bad files       5   2 tracked, 3 untracked
```

Then the detail tables. Lead with secrets: a secret that was pushed is exposed already, so removing it is not enough. Say to rotate it.

## 3. The owner picks

Per group: `all`, `none`, or the row numbers to keep or drop. Silence is not a pick. Change nothing until every group has an answer.

## 4. Apply

1. Uncommitted work in the repo -> stop and ask the owner to commit or stash it first.
2. Branch from the current HEAD: `sweep-<yyyymmdd>`.
3. One commit per group, in this order: secrets and PII, bad files, comments, tests.
   - **Bad files:** add the patterns to `.gitignore`, `git rm --cached` the tracked ones. Move untracked ones to `~/.carry/sweep/<repo>/<yyyymmdd>/`, never `rm`: they are not in git, so a delete cannot be undone.
   - **Comments:** delete only the comment, keep the code byte for byte. Never touch a string that only looks like a comment.
   - **Tests:** delete whole cases, never weaken an assertion. A file left with no cases goes.
4. Run the repo check (`check` in `.carry/repo.toml`, or the repo's test command) after the comments and tests commits. Red after comments -> a comment was code: find it and fix that commit. Red after tests -> a kept test depended on a deleted one: show the owner.
5. Never push. Never rewrite history.

## 5. Reply

- Line 1: the branch and the commits, one per group, with counts.
- The check result.
- Where moved files went.
- **You:** review `git diff <base>...sweep-<yyyymmdd>`, then merge it or open a PR. For a secret in history: rotate it, and rewriting history is your call (`git filter-repo`), never carry's.
