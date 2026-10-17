---
name: setup
description: Set up or refresh carry for one git repo. Writes .carry/repo.toml with how to check, run and seed it, .carry/rules.md with its rules and how to drive it, proves it by driving one feature, and registers it so other repos can link to it. Asks the machine settings once per machine. Use for /carry:setup (optionally with a path), when a repo has no .carry/ yet, when a repo has no rules file, or after a repo's tooling changes.
disable-model-invocation: true
---

# Setup

**Write down, once, everything an agent needs to work in a repo without asking.** The output is read cold, mid-task, by a builder or verifier that has never seen the repo.

Read the repo, not the owner. Ask the owner only what the repo cannot answer, with a suggested answer. One repo per run: `/carry:setup <path>` sets up that repo, otherwise the one this session started in.

## Steps

1. **Init.** `carry init` in the repo. It creates `.carry/` from the template, keeps `.carry/quests/` out of git, and registers the repo by name in `~/.carry/repos.toml`.
2. **Machine questions, only when `carry where` says `machine_config` is missing.** Once per machine, each with a suggested answer:
   - The owner's name.
   - Builder model. Suggested: opus.
   - Verifier tool and model. Suggested: a different model from the builder, e.g. claude sonnet, or codex if installed. The same model is the owner's choice.
   - Where worktrees go. Suggested: `~/.carry/worktrees/`.
   - The carry status line, which shows the open quest and where it stands at the bottom of Claude Code. Suggested: yes.
3. **Read the repo:** `CONTRIBUTING`, `AGENTS.md` or `CLAUDE.md`, the README, git hooks, linter and formatter config, CI config, the test layout, `Makefile` or `package.json` scripts, how it starts, what it needs (database, other services, env vars).
4. **Repo questions, only what the repo cannot answer.** Usually:
   - The name other repos use for it. Suggested: the folder name.
   - The base branch. Suggested: the detected default (e.g. `origin/main`).
   - Other repos it calls or is called by. Each one that is not set up yet -> offer setup for it after this one. Skip -> `carry skip <dir>`.
5. **Show the owner one summary:** the answers, the detected commands and database. Write nothing until they confirm.
6. Write `~/.carry/config.toml` from `../mode/templates/machine.example.toml`, if step 2 ran.
   - Status line, if the owner said yes. `~/.claude/settings.json` has no `statusLine` -> add `"statusLine": {"type": "command", "command": "<carry root>/bin/carry status --line --stdin"}` (`carry root` prints the path). It has one -> never replace it. Show the owner the two lines to add to their script instead: keep stdin in a variable, then pipe it into `carry status --line --stdin`.
7. Write `.carry/repo.toml` from `../mode/templates/repo.example.toml`: `[repo]` with `name`, `base`, `check`, `run`, `seed`, `seed_after_up`, `logs`, `review_port`; `[sandbox]` with `create` and `drop`, empty without a database. Placeholders: `{port}` `{db}` `{wt}` `{log}` `{port:<other-repo>}`.
8. Write `.carry/rules.md` from `../mode/templates/rules.md`. Every value from this repo, no placeholders.
   - **Rules:** the repo's real conventions, what not to touch, how its tests are written, its commit rules. Only what an agent would otherwise get wrong.
   - **Drive it:** launch and ready signal, one read-only doctor check, how to drive it like a user (routes, commands, accessible names), what evidence to capture, cleanup.
9. Prove it in a throwaway quest named `setup-<yyyymmddhhmm>`: `carry quest <it> --side`, `carry prep <it>`, `carry up <it>`. Run the doctor check, drive one user-facing feature found in the code, capture the evidence. Fix the files and re-run until it passes. Then `carry drop <it>`.
10. Commit nothing. Tell the owner which `.carry/` files are worth committing for teammates: `repo.toml` and `rules.md`.

`/carry:setup` again later refreshes steps 3, 7, 8 and 9. The machine answers stay.

## Growing the rules later

When the owner bounces review work because of a repo convention, carry proposes one line for that repo's **Rules**. Add it only after the owner confirms. Keep the file short: a rule that never changed an outcome can go.

## Starting over

`carry throw` removes this repo's `.carry/`, its worktrees and sandboxes, and its registry entry. `carry throw --skips` forgets every remembered skip. `carry throw --all` removes `~/.carry/`. Each prints its plan first and needs `--yes`; show the owner the plan and run it only on their confirmation. Code and branches are always kept.

**Reply:** the config entry, the rules found, the feature driven end to end with its evidence, anything that could not be driven and why, questions for the owner with suggested answers.
