---
name: start
description: Start flow for every code change. Writes one quest per repo, a checklist plan where every box names its evidence, a main or side quest, feature or fix. The owner confirms a main quest; a side quest is approved by the agent unless the owner says "plan first". The build skill builds it, the owner reviews it, then the PR. Product intent comes from a spec elsewhere. Internal: the mode skill routes every code change here.
disable-model-invocation: true
user-invocable: false
---

# Start

**You own the plan, not the code. The plan is a checklist the builder runs box by box and the owner audits from the evidence.**

The quest says how a change is built and proved. What and why live in the product spec it links. A product question the spec does not answer goes back to its owner with a default; never decide it.

## What a quest is

- **One quest = one repo = one worktree = one branch = one PR.**
- A change across repos is one quest per repo. The repo that provides data (an API) owns the **Contract**: endpoints, fields with types, statuses, errors. Additive only. A repo that consumes it says `uses: <repo>:<slug>`: it builds against the contract, runs against that quest's branch, and its verifier checks end to end. A builder that finds the contract unworkable stops with `contract-gap`; nobody edits it in place.
- Two quests in the same repo only when the parts could ship and be reviewed alone. Dependent work stays in one quest.
- **Follow-up:** new work after building started, or after the owner tried the result, is a new quest with `continues: <quest>`. Same worktree and branch, its own small plan and review, its commits land on the same PR.

Weight, per the routing table in `../mode/SKILL.md`. Pick it yourself; the owner never has to name it.

- **side quest**: a tweak or a fix with no high-impact test tripped. Builder only. Its evidence is the proof; the owner reviews the diff. You approve it yourself, unless the owner said "plan first", "let me see the plan", or similar.
- **main quest**: everything else. The owner confirms the plan. An independent verifier, usually on a different model, runs every Verify, live box in its own sandbox.

## Steps

1. Read the request, the spec, the code it touches and `carry repos`. Decide the quests: one per repo touched, plus any truly independent split.
   - More than one quest -> show the owner the list first: slug, repo, main or side, which uses which.
   - A repo the change needs is not set up -> offer the **setup** skill for it first. The owner skips it -> the change stays out of that repo; say what that leaves undone.
2. Open each. In this repo: `carry quest <slug>`. In another repo: `carry quest <repo>:<slug>`; the quest lives in that repo's `.carry/`.
   - A fix -> `--fix`. A side quest -> `--side`. A main quest is the default.
   - Consumes a quest in another repo -> `--uses <repo>:<slug>`.
   - A follow-up -> `--continues <slug>`, in the same repo as the quest it continues.
3. Explore each repo read-only with subagents; each returns file pointers, conventions, test commands, entry points.
4. Settle what you can before writing.
   - A fix -> the **diagnose** skill (`../diagnose/SKILL.md`), then fill Diagnosis.
   - Moves or rebuilds a lot of data -> measure first: run the real path on a small slice and extrapolate. Fits the live box budget -> the verifier runs it in full. Does not -> the verifier proves it on a seeded slice, and the full run is listed as an owner run after review, with the measured estimate.
   - An open technical question -> a spike, per `../mode/SKILL.md`: try it in a scratch folder, throw the code away, and log the result as `made:`. A main quest also records it in Appendix A.
   - A product question the spec does not answer, and no spike can settle -> `carry log <slug> "raised: <question> | suggested: <answer>"` and ask the owner. Keep planning everything that does not depend on it.
   - **Check every shape you will write against the repo first.** The error envelope, route paths and prefixes, status codes, field casing, pagination: copy them from an existing endpoint or screen (`file:line`), never from memory. A plan that guesses a shape stops the verifier.
   - **Uses a quest in another repo** -> read that quest, its repo's `rules.md` and its `repo.toml` (mode, config, ports, seed) before writing any live box that crosses into it.
   - **Branches from something other than the repo's base** -> `carry quest <slug> --base <ref>`.
5. Fill the template. Keep every heading in order. One `## Task:` section per unit of work. Every box names its evidence.
   - Main quest -> **Flow**: five to ten lines, numbered steps or a small diagram. What runs in parallel, what waits on what, where carry hands values across repos (a branch, a port, a seeded id). When several quests ship together, show the same Flow to the owner with the quest list.
   - Main quest -> each live box starts with its surface: `api`, `cli`, `component`, `browser` or `sim`. Pick the cheapest that proves it. Most UI boxes are `component` (a state renders) or `api` (the data behind it is right); keep `browser` for one or two journeys that cross screens or the stack, and group boxes on one journey.
   - Has `browser` boxes -> pick how screens are driven in the `ui:` frontmatter, and say it with the Flow:
     - `script` (default): repeatable checks on the repo's `.carry/ui` harness.
     - `agent`: no scripts. The builder and verifier drive the browser tool their harness gives them and judge the screenshots. Take it when the owner asks, or when the repo has no harness and adding one is not worth it for this quest.
   - Has `browser` boxes -> pick how screens are driven, in the `ui:` frontmatter, and say it with the Flow: `script` (default: repeatable checks on the repo's `.carry/ui` harness) or `agent` (no scripts: the builder and verifier drive a browser tool their harness gives them, and judge the screenshots). Take `agent` when the owner asks, or when the repo has no harness and adding one is not worth it for this quest.
   - Main quest -> each task has at least one `L<n>. ... Pass when ...` box.
   - Main quest -> Downstream lists every number the platform reports from this data (a balance, a valuation, a return), each with a live box that ties it out. The builder only touches the feature; the verifier catches the rest.
   - Used by another quest -> the Contract says exactly what this repo provides.
6. `carry lint <slug>` (or `<repo>:<slug>`) for each quest. Fix every line it prints.
   - A side quest trips a "Stays a side quest" test -> `carry quest <slug> [--fix]` re-opens it as a main quest and keeps the draft.
7. Approve.
   - Side quest -> `carry approve <slug> --self` (add `--reason "<owner's words>"` only when the owner said why), tell the owner the one-line change in one line, and go straight to step 9. The owner said "plan first" -> show them the one-line change and the task headings, then wait as for a main quest.
   - Main quest -> show the owner the Flow, the summary, the tasks, the live boxes with their surfaces, the contract, and every default you took, then wait.
8. The owner confirms a main quest -> `carry approve <slug>`.
   - A change before building starts -> edit, show the owner what changed, approve again.
   - After building starts the plan does not change, so builder and verifier judge the same text. New work is a follow-up: `carry quest <new> --continues <slug>`. The CLI refuses an edited plan once building started.
9. Run the **build** skill: follow `../build/SKILL.md`. It ends with `review.md`, whether the work passed or stopped.
10. The owner answers the review. Record each answer in the Verdict column of `review.md`: `accept`, or `bounce: <why>`.
    - Accept -> `carry sync <slug>`. Patch changed -> re-run the check, and the verifier for a main quest. Push, open the PR (or update it, for a follow-up) with `../mode/templates/pr.md` as the body. `carry done <slug> <pr-url>`.
    - Bounce -> the build skill judges: a box not really done -> another round of this quest; new scope -> a follow-up quest. Either way the plan that was built does not change.
    - A stop -> the owner decides: take a default, a follow-up, or drop.
    - Drop -> `carry drop <slug>` once the owner confirms. It deletes the worktree, branch and sandboxes; for a follow-up it resets the shared branch to where that follow-up started.
11. Merge is the owner's. `carry tidy` later removes merged quests with their worktrees, branches and work files; the PR is the record.

## Commands

```sh
carry quest <slug> --side
carry quest <slug> --fix
carry quest <repo>:<slug> --uses <other-repo>:<other-slug>
carry quest <slug> --continues <other-slug> --side
carry lint <slug>
carry lint <repo>:<slug>
carry approve <slug>
carry approve <slug> --self
carry log <slug> "made: <choice> | because: <why> | to change: <what to say>"
carry status <slug>
carry sync <slug>
carry done <slug> <pr-url>
carry drop <slug>
carry tidy
```

**Reply:** at step 7, a side quest: one line. A main quest: the summary, the tasks, the live boxes, decisions with reasons. After build: verdict, boxes ticked, review path and URLs. After done: the PR link.
