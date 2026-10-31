---
kind: review
quest: {slug}
urls: {review_urls}
---
## Tested

Every scenario the verifier ran (or the builder, for a side quest), so you know what is already proven.

| Box | Surface | What it did | Result | Replay | Evidence |
|---|---|---|---|---|---|
| L1 | api | | pass | match | scenarios/L1.out |

## Look at these

What only a human can judge. While the work is on a branch, every link is the local review server from `carry review`; after merge, the real URL.

| # | Open or run | What changed | What you should see | Verdict |
|---|---|---|---|---|
| 1 | http://127.0.0.1:<port>/<route> | | | |

For an API, the exact call: `curl -s http://127.0.0.1:<port>/<path> \| jq`.

## Diff
| Repo | Files | + | - | Branch |
|---|---|---|---|---|

## Open prerequisites

Every `prerequisite:` a verify round passed on a workaround, or none. Each stays open until someone outside the quest resolves it.

## Rounds

| Round | Took | Stopped by | Cause: plan, product, verifier or carry | Late findings |
|---|---|---|---|---|

## Calls I made

Every `made:` line from the quest's Calls, word for word, or none. Say which to change.

## Try these
- unusual cases worth a click, each with its local link

Reply per row in Look at these: accept, or bounce with why.
