# AGENTS.md

Instructions for AI coding agents working in this repository. Tool-agnostic;
`CLAUDE.md` imports this file.

## Project

Docker image with Exim4 (`exim4-daemon-light` on `debian:bookworm-slim`) that
lets other containers send mail over SMTP port 25, either directly
(`internet`) or through a smarthost (`satellite`). All configuration comes
from environment variables, translated by `docker-entrypoint.sh` into Debian's
`update-exim4.conf.conf`. Multi-arch build (`linux/amd64`, `linux/arm64`) in
CI. No license file.

## Read first

1. `docs/README.md` (index).
2. The topic doc for the area you touch:

| Area | Doc |
| --- | --- |
| Files, startup flow, invariants | `docs/architecture.md` |
| Environment variables | `docs/configuration.md` |
| CI workflows, registries, image tags | `docs/deployment.md` |

## Commands

```bash
shellcheck docker-entrypoint.sh          # same check as CI job lint
hadolint dockerfile                      # same check as CI job lint
docker build -f dockerfile -t exim4-smtp:dev .
```

There are no tests and no `Makefile`. The Dockerfile is named `dockerfile`
(lowercase); always pass `-f dockerfile`.

## Definition of done

- `shellcheck docker-entrypoint.sh` passes; `hadolint dockerfile` passes when
  available.
- Affected topic doc in `docs/` updated.
- New file `docs/changes/YYYY-MM-DD-<slug>.md` (template in
  `.claude/skills/document-change/SKILL.md`), listed in `docs/README.md`.
- New or changed environment variable: `readme.md` table,
  `docs/configuration.md` and `docker-compose.yml` updated together.

## Hard rules

- `docker-entrypoint.sh` is POSIX `sh` (`#!/bin/sh`, `set -e`). No bashisms.
- The entrypoint must end with `exec "$@"` so Exim runs as PID 1 with the
  image `CMD` (`exim -bdf -v -q30m`).
- Values are written inside single quotes into `update-exim4.conf.conf`.
  Do not introduce values that need other quoting without escaping.
- Default `RELAY_NETS` stays limited to private ranges
  (`10.0.0.0/8;172.16.0.0/12;192.168.0.0/16`); never default to an open
  relay.
- Never commit real SMTP credentials. `docker-compose.yml` and `readme.md`
  contain placeholders only (`user@gmail.com`, `your-app-password`).
- Keep `dockerfile`, `docker-entrypoint.sh` file names: both CI workflows
  reference them.
- Do not push tags `v*.*.*` or to `main` unless the user asks: both publish
  images.
- No emojis in code, logs or docs.

## Language

| Artifact | Language |
| --- | --- |
| Code, scripts, `readme.md` | English |
| Comments in `docker-compose.yml` and workflow files | German (existing) |
| Commit messages, `docs/` | English |

Commits: Conventional Commits, imperative, no tool attribution trailers.

## Project skills

Located in `.claude/skills/<name>/SKILL.md`. Other agents can read them as
step-by-step playbooks.

| Skill | Use for |
| --- | --- |
| `add-env-option` | Expose another Exim/Debian `dc_*` option as an environment variable |
| `document-change` | Writing the `docs/changes/` record |
