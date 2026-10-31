---
kind: verify-report
quest: {slug}
round: {n}
verdict: pass | fail | blocked
stop: none | spec-gap | infra | contract-gap | grew
fixed: 0
open: 0
new: 0
prerequisite: none
---
## Expectations

Written from the quest alone, before reading any code.

| box | the product must | confidence |
|---|---|---|

## Results

Mode, for a failing row: `defect` behaviour differs from a quest line. `test` the repo check fails. `server` crash, 5xx or timeout, with log lines. `expectation` you misread the quest and corrected it, not a finding. `spec-gap` the quest is silent or ambiguous. `infra` sandbox, database, port or toolchain failed. `contract-gap` the contract cannot work as written. A spec-gap, infra or contract-gap row sets `stop` to that mode.


| # | box | result | mode | evidence | owner |
|---|---|---|---|---|---|
| 1 | L1 | pass / fail | - | scenarios/L1.out | - |

`prerequisite`: an outside dependency the quest logged a workaround for. The box passes on the workaround; name what is still open, e.g. `staging SSO not issued, used the seeded test login`.

## Extra

Diff against the Build boxes: anything missing, anything extra. Or none. Each finding here is also a Results row; point to it as `#<n>`, or it never reaches the builder.

## Check

The repo check command and its pass count.

## Fail-first

Each test file the diff adds or changes, and its result on the base: `fails` (good) or `passes` (a `test` row).

| test file | on the base |
|---|---|

## Corrected expectations

none
