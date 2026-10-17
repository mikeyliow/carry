---
kind: quest
type: {type}
weight: side
state: draft
slug: {slug}
repo: {repo}
uses: {uses}
continues: {continues}
spec: TODO link to the request or spec, or none
opened: {date}
approved:
hash:
---
# {slug} plan

TODO one line: before -> after, as the user or caller sees it.

## How to read this

One box is one unit of work. Every box names the evidence that checks it. Check a box only when its evidence exists. Side quest: no verifier. The builder's evidence is the proof, and the owner reviews the diff. Once building starts, this plan does not change.

## Checklist

- [ ] Approved: by the owner, or by carry for a side quest the owner did not ask to plan first.
- [ ] Every task below is checked with its evidence.
- [ ] The owner reviews the diff.
- [ ] Rebased on the latest base, check re-run, PR opened.

## Diagnosis

TODO reproduction (measured), root cause at file:line, why nothing caught it.

## Task: TODO a verb phrase

**Files.**

- [ ] TODO Edit `path`.

**Build.**

- [ ] TODO one change. Name the symbol and the file.

**You see.**

- [ ] TODO the command, request or click, and what it shows before and after.

**Verify, unit.**

- [ ] TODO test file and the case it gains. Run `command`.

## Stays a side quest

| Test | Answer |
|---|---|
| Stored data must be corrected | no |
| Changes a shape others rely on | no |
| A revert does not undo it | no |
| Touches auth, permissions or money, or can lose data | no |
| A product question has no safe default | no |

## Calls

Calls made while planning or building, added with `carry log`; not part of the confirmed plan.

- `raised:` a product question for the owner, with a suggested answer. `ruled:` how the owner answered.
- `made:` a call made without asking: what was chosen, why, and what the owner can say to change it.
