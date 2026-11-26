@AGENTS.md

## Claude Code specifics

- Project skills live in `.claude/skills/`. Invoke the matching skill before
  starting a task it covers.
- `.claude/settings.json` allows the lint commands and the local image build,
  asks before `git push` and image pushes, and denies reading `.env`.
- Run `shellcheck docker-entrypoint.sh` before reporting a task as done.
