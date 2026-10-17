# carry

A workflow for building product changes with agents. You set it up per repo, and repos link to each other when a change crosses them. You decide what gets built and what ships. Agents plan, build and prove the work in between.

This README is the only file written for people. Everything under `skills/` and `agents/` is written for agents.

carry is a harness built for Claude Code. It relies on Claude Code's skills, subagents and hooks, so adapt it with care before using it with another coding agent.

## Two flows

- **start** for any code change: a fix, a tweak or a feature.
- **run** for everything else: a question, a script, an API call, a reseed, a deploy.

The product spec (what to build and why) lives wherever your team keeps it. carry starts from it and only covers how the change is built and proved.

## carry mode

In a repo you set up, every session is in carry mode. You don't call anything to turn it on.

- **Planning:** while no quest is open, you think it through together. carry reads the code, runs spikes and shapes the change with you, and doesn't push for a confirmation. It opens a quest once the work is clear.
- **Questing:** once a quest is approved, carry drives it through build, verify and review, and stops only where you decide.
- **Knowing where you are:** each of your messages reaches the agent with a status line like `carry · api · ⚔ side fix-csv-totals · building r1 · 3/6 tasks · builder r1 12m · last: Build export query`, and every reply ends with it. When a quest moves, the reply starts with a banner:

```
── ⚔ SIDE QUEST fix-csv-totals · drafting ──
── ⚔ SIDE QUEST fix-csv-totals · building r1 ──
── ⚔ MAIN QUEST holdings-export · verifying r1 ──
── ⚔ SIDE QUEST fix-csv-totals · review ready ──
```

  Status reads drafting, approved, building r1, verifying r1, writing review, review ready, accepted or done, and stopped when it needs you. `carry status` prints the same with a progress bar per quest, in tasks; `carry status --line` is the one-liner, which setup offers to put in the Claude Code status line (with `--stdin` there).
- **Cutting in:** say what you want changed while a quest is building. carry treats your message as the approval: if it contradicts what the builder is doing, it restarts the round on the same branch (`── ⚔ MAIN QUEST export · reopened: ... ──`); otherwise it queues the change and builds it as a follow-up when the round ends (`· queued: ...`). "Restart it" or "just queue that" overrides its pick.
- **Check-ins:** `/carry:checkin`, or "where are we", answers in a fixed shape: done, running, left, blocked, you.
- **Pausing:** say "carry off" to pause the mode for this session, and "carry on" to bring it back. If a long session drifts, `/carry:mode` re-reads the rules and where every quest stands.

## Words

Five words cover it:

- **quest**: one change in one repo, one branch, one PR. A **main quest** (you confirm the plan, a verifier checks the build) or a **side quest** (approves itself, the builder's evidence is the proof).
- **plan**: the checklist in `quest.md`.
- **mode**: how a session behaves in a set-up repo. Planning until a quest is approved, questing after.
- **start**: the flow for a code change. `run` is the flow for everything else.
- **status**: where things stand, as a table, a one-liner or a banner.

The session you talk to is carry. The agents it spawns are builders and verifiers.

## Where you come in

`[YOU]` marks every point where carry stops for you.

```
start
  request, with a link to the spec
    -> the planner explores, diagnoses a fix, writes one plan per repo
    -> main quest: [YOU] confirm the plans
       side quest: the agent approves it and keeps going, unless you said "plan first"
    -> carry runs a builder per plan, each in its own worktree, database and port
         side: the builder's evidence is the proof
         main: an independent verifier re-checks it, end to end
               with any repo it depends on, up to 2 rounds
    -> [YOU] review what changed on running apps, or why it stopped
    -> rebased on the latest main, one PR per plan, merged by you

run
  question or task
    -> answers with evidence, back and forth with you
    -> [YOU] confirm before anything that changes state: writes, reseeds, deploys
```

carry picks the weight for you. They differ in whether you confirm the plan and how much proof is collected:

- **Side quest:** a tweak (a label, a column, a default) or a contained fix. No stop before building: the agent approves its own plan. Say "plan first" to see it before it builds.
- **Main quest:** anything that changes stored data, an API others rely on, auth or money, or that a revert cannot undo. Also new behaviour, or whenever you say so. You confirm the plan, and an independent verifier checks the build.

Either way, nothing merges without your review.

## The plan

A quest is one change in one repo. Its plan, `quest.md`, covers one worktree, one branch, one PR. It is a checklist where every box names the evidence that checks it: the files, the change, what you will see, the tests. A main quest's plan adds the scenarios the verifier runs, and appendices for decisions, rejected alternatives, risks and links.

Every plan ends with **Calls**: the product questions carry asked you and how you ruled, and the calls it made without asking, each with what you can say to change it. Before asking you anything, carry checks whether running something could answer it. If so, it runs a quick throwaway check (a spike) and logs the result as a call instead. `review.md` lists every call it made, so you see them all in one place.

- **Across repos:** one plan per repo. The repo that provides data (say the API) writes the contract. The one that consumes it (say the UI) builds against it, runs against the API's branch, and is checked end to end.
- **Splitting further:** only when parts could ship and be reviewed alone. Dependent work stays in one plan.
- **New ideas after building started, or after you tried it:** carry judges. A change of direction restarts the quest on the same branch; an addition is queued and built as a follow-up when the round ends; at review, a box that is not really done gets another round, and new scope becomes a follow-up. A follow-up continues on the same branch, so you test everything together, has its own small review, and its commits land on the same PR.
- **States:**
  - **draft:** being written.
  - **approved:** you confirmed it. Before building starts you can still change it and confirm again.
  - **done:** you accepted the review and the PR is open.
  - After you merge, `carry tidy` deletes the quest. The PR is the record.
  - If you drop it, carry deletes it with its worktree and branch, or for a follow-up, rolls the shared branch back to before it.

`carry status` lists every open quest and what it needs from you; `carry status <slug>` shows its next step and how many boxes are ticked, so any new session can pick up where the last one stopped.

## What it writes

Each repo you set up gets its own `.carry/` folder. Your machine keeps the rest in `~/.carry/`:

```
~/code/api/                   a repo you set up
  .carry/
    repo.toml                 how to check, run and seed it, its review port
    rules.md                  its rules and how to drive it, written by setup
    quests/<slug>/            open quests, kept out of git
      quest.md                the plan, plus its Calls: questions you ruled on and calls made without you
      review.md               what to check before the PR; you answer here

~/.carry/
  config.toml                 your name, which model plays which role, max_parallel
  repos.toml                  every repo set up on this machine, and the ones you skipped
  worktrees/<repo>/<slug>/    one checkout per quest
  work/<repo>/<slug>/         agents only: briefs, reports, test scenarios, logs, sandboxes
```

You read `quest.md` and `review.md`; everything agents write stays out of your repo. Nothing else is kept: the code, its tests and the PR are the record, and `rules.md` holds what agents would otherwise get wrong. `repo.toml` and `rules.md` are worth committing so teammates get them; that is your call.

A quest in another repo is named `<repo>:<slug>`, for example `api:export-csv`. carry finds that repo through `~/.carry/repos.toml`, so the repos can live anywhere.

Worktrees live outside your repos, so editors and test runners never see a second copy of the code; a follow-up reuses its quest's worktree. At most 3 agents build at once on your machine (`max_parallel`). After you merge, `carry tidy` removes the worktree, the branch, the sandboxes, the quest and its work files. Anything with uncommitted work is shown to you, never deleted.

## Setup

Install once per machine, from a terminal (or the same commands as `/plugin ...` inside Claude Code):

```
claude plugin marketplace add mikeyliow/carry
claude plugin install carry@mikey
```

To pick up changes later: `claude plugin marketplace update mikey`, then restart Claude Code.

From a local clone instead, or to try it for one session without installing:

```
claude plugin marketplace add ~/carry
claude plugin install carry@mikey
```

```
claude --plugin-dir ~/carry
```

Once per repo, from inside it:

```
cd ~/code/api
claude
```

```
/carry:setup
```

It reads the repo, asks only what it cannot find out, writes `.carry/repo.toml` and `.carry/rules.md`, and proves the repo by driving a real feature. The first setup on a machine also asks for your name, the models and where worktrees go. Run `/carry:setup` again after a repo's tooling changes.

Optionally put `bin/carry` on your PATH (`ln -s ~/carry/bin/carry ~/.local/bin/carry`) and run `carry doctor` once per machine. The commit guard only sees commands run inside Claude Code, so keep each repo's own commit hooks.

## Developing

A change in one repo:

```
cd ~/code/api
claude
```

```
fix the 500 on /holdings when the date is empty
```

A change across repos: start in one and add the others.

```
cd ~/code/api
claude --add-dir ../web
```

```
add CSV export to holdings, API and web
```

carry checks every folder you added. A repo that is not set up gets one question: set it up now, or skip it as a reference. It remembers a skip, so you are not asked again. Folders that are not git repos, like specs or docs, are just read.

carry picks the flow, or call one directly:

```
/carry:start     a code change: "fix the CSV export totals", "add a status filter to orders"
/carry:run       anything else: "why did yesterday's import fail", "reseed staging"
/carry:diagnose  trace something broken to its cause
/carry:mode      re-enter carry mode: re-reads the rules and where every quest stands
```

What you do along the way: confirm main quest plans, review the result and the calls made, merge the PRs. To see where everything stands, or to resume after a break:

```
carry status            this repo's open quests, the linked ones in other repos, and what they need from you
carry status <slug>     one quest's next step
carry status --line     the one-liner the agent sees each turn
```

In a new session, "continue" is enough: the session starts with the open quests listed.

Build and verify run inside start, so they are not commands you call.

## Starting over

```
carry throw             in a repo: remove its .carry/, worktrees, sandboxes and registry entry
carry throw --skips     forget the repos you skipped
carry throw --all       remove ~/.carry/: machine settings, the repo list, all worktrees
carry reopen <slug> "<why>"  stop a quest's agents and reopen its plan; branch and commits kept
```

Each prints what it will remove and does nothing until you add `--yes`. Your code and branches are always kept.

## House rules

These hold everywhere. Each repo adds its own in `.carry/rules.md`.

1. The spec decides product questions. When it is silent, carry asks you with a suggested answer, and never guesses.
2. No AI attribution in commits, PRs, code or docs.
3. No code comments.
4. Minimal tests that call the code like a user.
5. Every build and check runs in its own worktree, port and database.

## Models

Each role's tool and model is set once per machine in `~/.carry/config.toml`; a repo can override them in its `repo.toml`. We recommend the verifier runs on a different model from the builder (your choice), so it doesn't share the builder's blind spots.

```toml
[role.build]
tool  = "claude"
model = "opus"

[role.verify]
tool  = "claude"
model = "sonnet"
```

## Layout

```
skills/
  mode/            entry: routing, house rules, where you decide
    templates/     main-quest, side-quest, build-report, verify-report,
                   review, pr, rules, machine.example.toml, repo.example.toml
  start/           flow: every code change
  run/             flow: everything else
  diagnose/        trace a problem to its cause
  setup/           one repo's config and rules
  build/           carry as orchestrator: builders, verifiers, the review
  checkin/         a progress check-in in a fixed shape
  verify/          the independent verifier
agents/            builder, verifier, checker
hooks/             session-start, prompt-status (the per-turn status line), commit-guard
bin/carry          the CLI the agents use
```
