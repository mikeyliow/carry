---
name: run
description: Run flow, for anything that is not a code change. Answers questions with evidence, back and forth with the owner, and runs scripts, API calls, reseeds and deploys. Anything that would change state is shown first and runs only after the owner confirms. Internal: the go skill routes questions, scripts and deploys here. Works in any folder, git or not.
disable-model-invocation: true
user-invocable: false
---

# Run

**Anything that is not a code change. Dig, act, report. Before anything changes state, show it and wait for the owner to confirm.**

A back and forth with the owner, not a checklist. Each turn: what you found or did, its evidence, what is still open, and what you would do next. The owner steers.

## Every turn

- Use whatever settles it: code (`file:line`), git history, an API call, a query, logs, a script.
- A broad question -> split it and give the read-only parts to `checker` agents in parallel.
- Sources disagree -> show both and what would settle it.
- Something is broken and the question is why -> the **diagnose** skill (`../diagnose/SKILL.md`).
- It turns into a code change -> the **start** flow (`../start/SKILL.md`).

## Before anything changes state

A write, a `POST`, a migration, a reseed, a deploy, a push, a `GET` with side effects.

1. Show the owner: target (`local`, `staging`, `real`), each exact command, what each should print, how to undo it.
2. Wait for the owner to confirm. Local, sandboxed and reversible needs none.
3. Run each step as shown. First mismatch with what it should print -> stop, show the output and the undo.

A deploy is a run like any other: show the steps, wait for the owner, run them, check the result.

**Reply:** the answer or result in one or two lines, then `| claim | measured / inferred / guessed | evidence |`, then what is still open and what you would do next. After a change: steps run of steps shown, anything left changed.
