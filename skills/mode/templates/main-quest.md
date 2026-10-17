---
kind: quest
type: {type}
weight: main
state: draft
slug: {slug}
repo: {repo}
uses: {uses}
continues: {continues}
spec: TODO link to the product spec this delivers, or none
opened: {date}
approved:
hash:
---
# {slug} plan

TODO under ten lines: what changes in this repo, for whom. What and why live in the spec; this plan says how it is built and proved.

## How to read this

One box is one unit of work. Every box names the evidence that checks it. Check a box only when its evidence exists: a file, a log line, a screenshot, a test run, or a SHA. carry ticks boxes; builders and verifiers report the evidence.

Main quest: an independent verifier runs every **Verify, live** box in its own sandbox. When this quest uses another, it also checks end to end against that quest's branch.

Once building starts, this plan does not change. New work goes in a follow-up quest on the same branch.

## Checklist

- [ ] The owner confirms this plan.
- [ ] Every task below is checked with its evidence.
- [ ] The verifier passes every Verify, live box.
- [ ] The owner reviews `review.md`.
- [ ] Rebased on the latest base, check re-run, PR opened.

## Diagnosis

TODO context, reproduction (measured), hypotheses ruled out, root cause at file:line, why nothing caught it.

## Contract

TODO when another quest uses this one: endpoints, fields with types, statuses, errors. Otherwise none.

## Downstream

TODO every number or view the platform reports from the data this quest touches or produces, and the live box that ties each one out. Otherwise none.

## Task: TODO a verb phrase

**Files.**

- [ ] TODO Edit `path`.

**Build.**

- [ ] TODO one change. Name the symbol and the file.

**You see.**

- [ ] TODO one observable result, with the exact output or screen state.

**Verify, unit.**

- [ ] TODO test file and the case it gains. Run `command`.

**Verify, live.**

- [ ] L1. TODO given, steps. Pass when TODO, within TODO min.

**Review gate.**

- [ ] TODO what the owner looks at, and where. Or none.

## Appendix A. Decisions

TODO each choice made while planning, and why. A product question goes back to the spec; list it with the default taken.

## Appendix B. Alternatives rejected

TODO each approach weighed and why it lost.

## Appendix C. Risks

TODO each risk and what to watch.

## Appendix D. Links

TODO the spec, related quests, docs to read before editing.

## Calls

Calls made while planning or building, added with `carry log`; not part of the confirmed plan.

- `raised:` a product question for the owner, with a suggested answer. `ruled:` how the owner answered.
- `made:` a call made without asking: what was chosen, why, and what the owner can say to change it.
