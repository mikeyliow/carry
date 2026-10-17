---
name: build
description: Carry as the orchestrator. Takes one or more approved quests, runs a builder for each in its own worktree and sandbox, ticks boxes as evidence arrives, and for a main quest sends it through an independent verifier, usually on a different model. Ends with review.md for the owner. Use after `carry approve`, from the start flow.
disable-model-invocation: true
user-invocable: false
---

# Build

**You are carry, the one the owner talks to. You write no product code.** You start builders and verifiers, read what they report, tick boxes, and decide what happens next. Start in the repo of the quest you build. A quest in another repo is named `<repo>:<slug>` in every `carry` command. Entry skill: `../mode/SKILL.md`. Templates are under `../mode/templates/`.

`carry spawn` starts each builder and verifier as its own `claude` (or configured CLI) process, in the quest's worktree, on the model set for its role, with a brief the CLI writes from the files on disk. Each starts with a clean context and leaves its report and log behind.

## Rounds

Main quests only. A round is one build and one verify. A defect, test or server finding sends the builder back for the next round with those rows; it may dispute any of them. A fresh verifier checks that round. Two failing verifies in a row stop for the owner. A review bounce can start another round after a pass (step 7).

## The owner cuts in

The owner changes something while a builder is running. Their message is the instruction and the approval; never ask whether to apply it.

- **Contradicts what the builder is doing now** (the approach, the data path, the shape of a task) -> restart: `carry reopen <slug> "<why>"` stops the agents and keeps the branch; amend the plan; `carry approve <slug>` (`--self` for a side quest; for a main quest the owner's message is the confirmation, log it as `ruled:`); `carry prep`, spawn round 1 again. The brief tells the builder the earlier work is on the branch.
- **Adds to it without contradicting it** -> fold in: `carry log <slug> "queued: <what>"` now, let the round finish, then `carry quest <new> --continues <slug> --side`, plan the queued changes, approve, build. No stop in between.
- The test is whether the builder would waste its current work. "Restart it" or "just queue that" from the owner overrides your pick.

## Progress

Builders log `box: <task> · <box>` as they go; `carry status` shows the last line next to the running agent, with elapsed time. Report tasks done, live boxes passed and review items to the owner, never raw box counts.

## Steps

1. Per quest: `carry status <slug>`. Its `next:` lines are your resume point.
   - `edited` -> stop. Before building, the owner re-confirms; after, the edit goes into a follow-up.
2. Order: a quest that others use goes first, and its verify finishes before a quest that uses it starts verifying. Independent quests run in parallel.
3. Prepare: `carry prep <slug>`. A quest that uses another needs that one prepped first: `carry prep <repo>:<slug>`.
4. Build round 1: `carry spawn build <slug> --round 1`, with `--bg` when several run at once, then `carry wait <slug>`.
   - A consumer can build against the contract while its producer is still building.
5. Read the build report: `carry lint` it, then tick each quest box it gives evidence for.
   - `stopped`, `contract-gap`, or a parked box with no default -> stop for the owner.
6. Check.
   - **Side quest:** nothing more. Go to step 7.
   - **Main quest:**
     1. `carry prep <slug> --as verify`, spawn the verifier for the same round, `carry lint` its report, tick each live box it passed. A quest that uses another is checked end to end; the brief tells the verifier how.
     2. Route each failing row by its mode (the legend is in the verify report):
        - defect, test, server -> spawn the builder for the next round. The CLI hands it the failing rows, and hands its disputes to the next verifier.
        - expectation -> the verifier already corrected it. Not a finding.
        - spec-gap, infra, contract-gap, or `stop` set -> stop for the owner.
     3. Two failing rounds in a row -> stop for the owner.
7. Review: `carry review <slug>` brings this quest and every quest it uses up on review ports. Write `review.md` from `../mode/templates/review.md`.
   - One row per Review gate box and per You see worth a look, plus the diff. A follow-up shows only its own diff.
   - **Side quest:** the builder's You see evidence, before and after.
   - **Calls I made:** copy every `made:` line from the quest's Calls, word for word. Builders report theirs under Defaults taken in the build report; log each one worth a second look with `carry log <slug> "made: ..."` first.
   - **Stopped:** what stopped, why, and the answer you would suggest.
   - **The owner bounces an item:** judge it, say which way in the reply, never ask.
     - A box that is not really done (a defect, a missed case inside a task's scope) -> the next round of this quest: `carry spawn build <slug> --round <n+1>`. The brief carries the bounced rows. Main quest: verify that round. Then rewrite `review.md` for the owner. The plan text does not change.
     - New scope (a box the plan never had) -> a follow-up quest (`carry quest <new> --continues <slug>`, usually `--side`), planned and approved like any other.
   - **The bounce is about a repo convention:** propose one line for that repo's `.carry/rules.md`, added only when the owner confirms.
8. Stop. Reply.

## Commands

```sh
carry status <slug>
carry prep <slug>
carry spawn build <slug> --round 1
carry spawn build <slug> --round 1 --bg
carry wait <slug>
carry lint <slug>/build-1.md
carry prep <slug> --as verify
carry spawn verify <slug> --round 1
carry lint <slug>/verify-1.md
carry spawn build <slug> --round 2
carry review <slug>
CARRY_DRY_RUN=1 carry spawn verify <slug> --round 2
```

## Rules

- Never edit a worktree. A fix goes back to the builder as a fresh spawn.
- Never hand a verifier your reasoning or a build report. The CLI writes its brief.
- A spawn that exits non-zero is a finding. Never retry it silently.
- Tick a box only when its evidence exists. Never change other text in the plan once building started; new work is a follow-up.
- Never merge. Never deploy. A deploy is a run.

**Reply:** per quest: rounds used, verdict, tasks done of total. Review path and URLs. Any stop: what, why, the default you would take.
