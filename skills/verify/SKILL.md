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
4. **Scenarios.** One script per `Verify, live` box, in the `scenarios:` folder your brief names: `L<n>.sh` (curl, CLI) or `L<n>.spec.ts` (browser). Use the absolute `report:` and `scenarios:` paths from the brief; your working directory is the worktree.
   - From the box, not the code. Given: the seed state, by its seeded names; missing state is created through the API, never by writing the database. Steps: method and path, or route and accessible name, or the command. Expect: fields, statuses or screen text, with a tolerance for numbers.
   - Ports from the `sandbox:` env file in your brief (it exists after `carry prep <slug> --as verify`). Exit 0 only when every expect held. Raw output beside it as `L<n>.out`.
5. Bring it up: `carry up <slug> --as verify`.
   - The quest uses another -> first `carry prep <repo>:<slug> --as verify` and `carry up <repo>:<slug> --as verify`, as your brief names them. At least one scenario per contract field crosses the boundary: produced by the used quest, consumed and shown by this one. Check every status the contract allows.
6. Run the repo check. Run every scenario.
7. Read the diff (`carry diff <slug>`) against the Build boxes and to explain failures. Report anything missing or extra.
8. Fill **Results**, one row per live box. When an expect fails, ask in order:
   1. Did I misread the quest? -> correct the expectation, re-run, list it under Corrected expectations. Mode `expectation`.
   2. Is the quest silent or ambiguous? -> `spec-gap`. Not your call.
   3. Did the server error or the sandbox fail? -> `server` / `infra`.
   4. Otherwise -> `defect`, with the request, the response and the quest line.

   A dispute in your brief -> re-check its quest line; agree, or keep the finding and say why. A dispute you keep is a `spec-gap`.
9. Round 2 and later: fill `fixed`, `open`, `new`. `open + new` >= the previous round's findings -> `stop: grew`.
10. `carry lint` your report. `carry down <slug> --as verify`, and the same for every quest you brought up, unless its `carry prep` said the sandbox already existed.

## Commands

```sh
carry prep <used-slug> --as verify
carry up <used-slug> --as verify
carry up <slug> --as verify
carry exec <slug> check --as verify
carry diff <slug>
bash <scenarios>/L<n>.sh
carry lint <report>
carry down <slug> --as verify
```

## Rules

- Write only your report and the `scenarios:` folder. Never product code, the quest, or a builder file.
- Never touch the builder's sandbox.
- A pass needs evidence from the real surface: the API called, the screen used, the CLI run. Inconclusive, or proven on another surface, is not a pass.
- The quest is silent or ambiguous -> `spec-gap`. Not your call.
- `blocked` only when your sandbox never ran. It is never `fail`.
