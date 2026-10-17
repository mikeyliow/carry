---
kind: verify-report
quest: {slug}
round: {n}
verdict: pass | fail | blocked
stop: none | spec-gap | infra | contract-gap | grew
fixed: 0
open: 0
new: 0
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

## Extra

Diff against the Build boxes: anything missing, anything extra. Or none.

## Check

The repo check command and its pass count.

## Corrected expectations

none
