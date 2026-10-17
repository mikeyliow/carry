---
name: checkin
description: A progress check-in on the open quests in this repo. Runs carry status, reads the agents' latest progress, and replies in one fixed shape: done, running, left, blocked, and what the owner needs to do. Use for /carry:checkin or "where are we".
---

# Check-in

1. `carry status`, then `carry status <slug>` for each open quest.
2. For a running agent, read the last `box:` lines in its quest log (`~/.carry/work/<repo>/<slug>/log.md`), not the agent's own log.
3. Reply in this shape, one line per item, nothing else:
   - **Done:** tasks finished, per quest.
   - **Running:** agent, round, elapsed, last box.
   - **Left:** tasks remaining, then verify and review if they are still ahead.
   - **Blocked:** stops, raised questions, queued changes. None -> say none.
   - **You:** what the owner needs to do now, or nothing.
