---
name: checkin
description: A progress check-in on open quests. Runs carry progress and replies in one fixed shape: done, running with elapsed time and an estimate from earlier rounds, left, blocked, and what the owner needs to do. Flags a stalled agent. `/carry:checkin all` covers every set-up repo on this machine, not just this one. Use for /carry:checkin or "where are we", "done?", "how long", "what's running everywhere".
argument-hint: "[all]"
---

# Check-in

1. Scope: the argument is `all`, or the owner asks about everything ("all quests", "everywhere") -> `carry progress --all`, every set-up repo. Otherwise `carry progress`, this repo.
2. It reads the files on disk: tasks, the running agent's own last line, elapsed time, and an estimate from the timings of earlier rounds in that repo.
3. A running agent says `STALLED` -> `carry wait <slug>` (`<repo>:<slug>` for another repo) to confirm, then follow the build skill: stop it and spawn the same round again. Say so in the reply.
4. Reply in this shape, one line per item, nothing else. With `all`, one block per repo, headed by its name:
   - **Done:** tasks finished, per quest.
   - **Running:** agent, round, elapsed, estimate left, last line.
   - **Left:** tasks remaining, then verify and review if they are still ahead.
   - **Blocked:** stops, raised questions, queued changes. None -> say none.
   - **You:** what the owner needs to do now, or nothing.
5. No estimate yet (a first round in that repo) -> say "no estimate yet", never guess one.
