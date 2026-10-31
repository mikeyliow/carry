---
name: diagnose
description: Trace something broken to its root cause with runtime evidence. Gathers context, reproduces, traces logs, data, contracts and history, rules out hypotheses, and weighs candidate fixes by impact. Used when planning a fix, by a builder handling verify findings, and by run for "why is X broken". Internal: reached through the go skill.
disable-model-invocation: true
user-invocable: false
---

# Diagnose

**Find the cause, prove it, then pick the smallest fix at the cause.** A change "that might help" is a guess. It does not ship.

Observe, never assume. Read the repo's `.carry/rules.md` first: it says how to start, drive and read logs for that repo.

## Steps

1. **Context.** Establish by observing: environment, account, data state, version or commit. Logs, read-only queries, the running app. Ask the owner only for what cannot be observed.
2. **Reproduce** on the surface where it was reported: the exact request, command or click, with its raw output.
   - Won't reproduce -> narrow the conditions, build the trigger yourself, or add a temporary log line in a sandbox.
   - No reproduction, no fix.
3. **Trace.**
   - Logs: `carry exec <slug> logs`, or the repo's own log command. Follow one request id. Read the first error, not the last.
   - Contract: compare the response with the contract. A wrong shape is almost always the provider's.
   - Data: is the state what the code assumed? Read-only query.
   - History: `git log -L` on the function, `git log -S` on the string.
   - Restart-only failures: suspect stale state first (caches, config files, locks).
4. **Hypotheses.** List them, each with the observation that would rule it out. Test the one that cuts the most first. Rule out until one survives with runtime evidence. A question about how something behaves is a spike, not a question for the owner: run it and log the result as a `made:` call.
5. **Candidate fixes.** Up to 3. For each: fixes the cause or the symptom, files touched, what else calls the changed code. Pick the smallest at the cause. Record the pick and the runner-up.
6. **Why nothing caught it.** A missing test, a wrong test, a seed gap, a box nobody wrote. The fix includes the test that would have caught it.
7. **Check for the pattern.** Search for the same mistake elsewhere in the repo. List the instances.

## When a builder uses this for verify findings

- `defect`, `test` and `server` rows in the brief are yours: steps 2 to 6 for each.
- A finding that contradicts the plan: dispute it in your report, quoting the plan's line. No line, no dispute.
- A round that closes as many findings as it opens: stop. Say the plan, the seed or the design is the likelier cause.

## Commands

```sh
carry exec <slug> logs
carry up <slug>
git log -L :<function>:<file>
git log -S '<string>' --oneline
```

**Reply:** the symptom, the reproduction with its raw output, hypotheses ruled out and how, the root cause at `file:line`, the fix and the runner-up, why nothing caught it, other instances of the pattern.
