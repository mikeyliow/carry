---
kind: plan-review
quest: {slug}
round: {n}
verdict: ready | revise
---
## Spec coverage

Every requirement in the spec or request, and the box that proves it. A requirement with no box is a finding.

| requirement | box |
|---|---|

## Findings

Kind: `missing` a requirement with no box. `weak` a Pass when that a wrong build could still pass. `shape` a path, field, status or error envelope that differs from the code (cite `file:line`). `weight` side when a main quest test trips, or the reverse. `downstream` a number the platform reports from this data with no box tying it out. `flow` an order or handoff that cannot work. `scope` a box the spec never asked for.

| # | kind | where in the plan | problem | suggested fix |
|---|---|---|---|---|

## Checked and fine

One line per area checked with nothing found: shapes, weight, downstream, flow.
