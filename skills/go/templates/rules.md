# {repo}

What this repo is, in one line. Who or what calls it.

## Rules

Only what an agent would otherwise get wrong here. One line each.

- Conventions: naming, layout, patterns this repo insists on.
- Do not touch: generated files, vendored code, migrations already applied.
- Tests: where they live, how they are named, what a minimal one looks like here.
- Commits: format, hooks that run, what they check.

## Drive it

- **Launch.** `carry prep <slug>`, then `carry up <slug>`. Ready when: the exact log line, endpoint or screen.
- **Doctor.** One read-only check that the right build is up with seeded data: the command and what it prints.
- **Drive.** How a user or caller uses it: real routes, commands, or accessible names. Stable handles, not positions.
- **Evidence.** What to capture per action: response bodies, screenshots, exit codes, rows. A second read-only view for every write.
- **Logs.** Where they go and how to follow one request.
- **Cleanup.** `carry down <slug>`. Kill only what you started.
