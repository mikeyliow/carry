---
kind: build-report
quest: {slug}
repo: {repo}
round: {n}
state: done | parked | stopped
boxes_done: 0
boxes_total: 0
---
## Evidence

One row per box in the quest.

| box | done | evidence: test run, output, SHA |
|---|---|---|
| | yes / no | |

## Findings

Round 2 only. One row per finding in the brief.

| finding | outcome | covering test |
|---|---|---|
| | fixed / disputed / not mine | |

## Disputes

none

## Defaults taken

none
