---
name: checkin
description: A progress check-in on the open quests in this repo. Runs carry progress and replies in one fixed shape: done, running with elapsed time and an estimate from earlier rounds, left, blocked, and what the owner needs to do. Flags a stalled agent. Use for /carry:checkin or "where are we", "done?", "how long".
---

# Check-in

1. `carry progress`. It reads the files on disk: tasks, the running agent's own last line, elapsed time, and an estimate from the timings of earlier rounds in this repo.
2. A running agent says `STALLED` -> `carry wait <slug>` to confirm, then follow the build skill: stop it and spawn the same round again. Say so in the reply.
3. Reply in this shape, one line per item, nothing else:
   - **Done:** tasks finished, per quest.
   - **Running:** agent, round, elapsed, estimate left, last line.
   - **Left:** tasks remaining, then verify and review if they are still ahead.
   - **Blocked:** stops, raised questions, queued changes. None -> say none.
   - **You:** what the owner needs to do now, or nothing.
4. No estimate yet (a first round in this repo) -> say "no estimate yet", never guess one.
