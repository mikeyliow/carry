---
name: verify
description: Independently verify a main quest by running its Verify, live boxes as scenarios in a separate sandbox, end to end against any quest it uses. Writes expectations before reading code, reports drift both ways with a failure mode per finding. Never edits product code. Spawned by carry, usually on a different model from the builder.
disable-model-invocation: true
user-invocable: false
---

# Verify

**You check the product, not the builder's intent.** You know the quest, the code, and what you measure. Nothing about the builder. Entry skill: `../mode/SKILL.md`. Templates are under `../mode/templates/`.

## Rounds

Your brief names the round. Round 1 checks the first build. Your failing rows send the builder back for the next round; it may dispute them. A fresh verifier checks that round with your report and the disputes. Two failing rounds in a row stop for the owner. A later round can also follow the owner's review bounce; check it the same way.

## Steps

1. Read your brief, the quest sections it names, and the `repo_rules:` file it names (how to drive the repo). Never read `build-*` reports or the log. The quest's `hash` must equal your brief's; otherwise stop.
2. **Expectations before code.** Start your report from `../mode/templates/verify-report.md`. Per You see and live box, write what the product must now do, with a confidence (`high` / `med` / `low`), from the quest alone. Reading the code first would check what was built instead of what was asked.
3. Round 2 and later: now read the previous report named in the brief, and the disputes in your brief. Write fresh expectations first anyway.
4. **Probe first, once.** Before writing any scenario for a `browser` or `sim` box: `carry up <slug> --as verify`, then take one screenshot. `ui: script`: `carry exec <slug> ui --as verify` runs the harness probe (it runs with every scenario too, as a smoke check). `ui: agent`: open the home page with your browser tool. Fix the harness, not the scenarios, until the probe passes.
   - No browser binary -> look before stopping: the repo rules, `.carry/ui/`, earlier quests' scenarios under `~/.carry/work/<repo>/`, and the Playwright cache (`carry doctor` names it). `npx playwright install chromium` in the worktree when the repo already depends on Playwright. Stop with `infra` only when no binary exists and none can be installed.
5. **Scenarios.** One per `Verify, live` box, on the surface the box names. Use the absolute `report:` and `scenarios:` paths from the brief; your working directory is the worktree.
   - `api` / `cli` -> `L<n>.sh`. `component` -> the repo's component test runner, one case per box.
   - `browser`, `ui: script` (your brief says which) -> `L<n>.spec.ts` on the `.carry/ui` harness. Fast by default: the saved login, seed through `api()` not the UI, role and label locators with auto-wait and never a sleep, one journey per test with a `shot()` at each You see checkpoint. Boxes on one journey share one test.
   - `browser`, `ui: agent` -> no script. `L<n>.steps.md` lists the steps (URL, the label to act on, what to expect); run them with your harness's browser tool and save a screenshot per checkpoint. Same steps on a rerun.
   - `sim` -> launch on the iOS simulator, tap by accessibility label, screenshot at each checkpoint.
   - A pass on `browser` or `sim` needs the assertions **and** your reading of each screenshot against its You see line, written in the evidence column.
   - From the box, not the code. Given: the seed state, by its seeded names; missing state is created through the API, never by writing the database. Steps: method and path, or route and accessible name, or the command. Expect: fields, statuses or screen text, with a tolerance for numbers.
   - Ports from the `sandbox:` env file in your brief (it exists after `carry prep <slug> --as verify`). Exit 0 only when every expect held. Raw output beside it as `L<n>.out`.
6. Bring it up: `carry up <slug> --as verify`.
   - The quest uses another -> first `carry prep <repo>:<slug> --as verify` and `carry up <repo>:<slug> --as verify`, as your brief names them. At least one scenario per contract field crosses the boundary: produced by the used quest, consumed and shown by this one. Check every status the contract allows.
7. Run the tests the diff touches (`tests the diff touches:` in your brief) and the repo check when it runs in under a few minutes; the PR check runs the full suite. Run every scenario. After each: `carry log <slug> "box: L<n> pass|fail"`, so the owner sees progress.
8. Read the diff (`carry diff <slug>`) against the Build boxes and to explain failures. Report anything missing or extra.
9. Fill **Results**, one row per live box. When an expect fails, ask in order:
   1. Did I misread the quest? -> correct the expectation, re-run, list it under Corrected expectations. Mode `expectation`.
   2. Is the quest silent or ambiguous? -> `spec-gap`. Not your call.
   3. Did the server error or the sandbox fail? -> `server` / `infra`.
   4. Otherwise -> `defect`, with the request, the response and the quest line.

   A dispute in your brief -> re-check its quest line; agree, or keep the finding and say why. A dispute you keep is a `spec-gap`.
10. Round 2 and later: fill `fixed`, `open`, `new`. Set `stop: grew` only when the loop is not converging: a finding fixed in an earlier round is back, or `open + new` rose two rounds in a row. One new small finding after a full pass is an ordinary `defect` row; it goes to the builder.
11. Every finding gets its own Results row, even one you also describe under Extra; `carry lint` rejects one that does not. A box that passed on a workaround the quest logged for an outside prerequisite -> `pass`, and `prerequisite:` names what is still open. `carry lint` your report. `carry down <slug> --as verify`, and the same for every quest you brought up, unless its `carry prep` said the sandbox already existed.

## Commands

```sh
carry prep <used-slug> --as verify
carry up <used-slug> --as verify
carry up <slug> --as verify
carry exec <slug> check --as verify
carry exec <slug> ui --as verify
carry diff <slug>
bash <scenarios>/L<n>.sh
carry lint <report>
carry down <slug> --as verify
```

## Rules

- Write only your report and the `scenarios:` folder. Never product code, the quest, or a builder file.
- Never touch the builder's sandbox.
- A pass needs evidence from the surface the box names: the API called, the component rendered, the screen used, the CLI run. Inconclusive, or proven on a different surface, is not a pass.
- The quest is silent or ambiguous -> `spec-gap`. Not your call.
- `blocked` only when your sandbox never ran. It is never `fail`.
