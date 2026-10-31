---
name: pass-the-ball
description: Hand this session to a new one, or pick up a handoff. With no handoff waiting it writes one (what is done, in flight, next, waiting on the owner, constraints still in force, files to read first), leaving out the discussion and anything settled that no longer limits the work. With a handoff waiting it reads it, checks it against the real state, takes it in, and deletes it so nothing trails. Works in any folder, git or not. Use for /carry:pass-the-ball, "pass the ball", "hand this off", "pick up where we left off".
---

# Pass the ball

**One command, two directions.** A handoff waiting for this folder -> catch it. None -> pass one.

```
session A                         session B
/carry:pass-the-ball  ──► ball ──► /carry:pass-the-ball
  write the handoff        file      check it, take it in, delete it
```

The ball lives at `~/.carry/balls/<key>.md`, outside the repo. `<key>` is this session's starting folder, absolute, with `/` replaced by `_`. Look first: `ls ~/.carry/balls/<key>.md`.

## Pass (no ball waiting)

1. Gather from the files, not memory: `carry status` and `carry progress` when this is a carry repo, `git status` and `git log --oneline -10` when it is git, and this conversation.
2. Write the ball from this shape. Points only, one line each, every pointer a path, SHA, PR or URL:

   ```markdown
   ---
   kind: ball
   folder: <absolute folder>
   passed: <yyyy-mm-dd hh:mm>
   ---
   ## Goal
   One line: what this work is for.

   ## Done
   - what is finished, with its pointer

   ## In flight
   - quests, running agents, branches, servers still up, uncommitted changes

   ## Next
   1. the next step, in order

   ## Waiting on you
   - each open question or approval, with the suggested answer. Or none

   ## Still holds
   - a decision or constraint that limits the next steps, as its outcome only: "kept X, so do not touch Y"

   ## Read first
   - the few files the next session needs, with why
   ```

3. Leave out: the discussion, options weighed, dead ends, anything settled that no longer limits the work, and anything already written in a file (point to the file instead). Aim for under 40 lines.
4. A ball is already waiting (an earlier one nobody caught) -> show the owner its Goal and Next, and ask before overwriting it.
5. Reply: the ball's path, then its Next in three lines or fewer. Tell the owner to open a new session in the same folder and run `/carry:pass-the-ball`.

## Catch (a ball is waiting)

1. Read it in full.
2. Check it against the real state. Run the same commands as Pass step 1 and compare:
   - A quest moved on, an agent finished, a branch merged, new commits -> note what changed.
   - A pointer that no longer exists -> note it.
3. Take it in: read the files under Read first, and work from the ball and its corrections from now on.
4. Delete the ball: `rm ~/.carry/balls/<key>.md`. Nothing trails into a later session.
5. Reply in this shape:
   - **Picked up:** the Goal, in one line.
   - **Changed since the pass:** each difference from step 2, or none.
   - **Next:** the first step, ready to start.
   - **Waiting on you:** from the ball, or none.
