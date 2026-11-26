---
date: 2026-11-25
type: docs
scope: docs, agent tooling
files: [AGENTS.md, CLAUDE.md, .claude/settings.json, .claude/skills/add-env-option/SKILL.md, .claude/skills/document-change/SKILL.md, docs/README.md, docs/architecture.md, docs/configuration.md, docs/deployment.md, docs/changes/2026-11-25-ai-ready-docs.md, readme.md]
breaking: false
---
# Agent-ready documentation and project skills

## Context

- The repository had no `docs/` folder and no instructions for AI coding
  agents. Knowledge lived in `readme.md`, `docker-entrypoint.sh` and the CI
  workflows.
- Goal: an agent can find files, rules and workflow without reading every
  file.

## Change

- `docs/README.md`: index of docs and change records, maintenance rules.
- `docs/architecture.md`: file map, startup flow, invariants.
- `docs/configuration.md`: every environment variable with default and
  `dc_*` mapping.
- `docs/deployment.md`: both CI workflows, registries, image tags, release by
  tag.
- `AGENTS.md`: tool-agnostic agent instructions.
- `CLAUDE.md`: imports `AGENTS.md` via `@AGENTS.md`, Claude Code notes.
- `.claude/settings.json`: allows `shellcheck`, `hadolint`, `docker build`;
  asks before `docker push`, `docker buildx build`, `git push`, `git tag`;
  denies reading `.env`.
- `.claude/skills/add-env-option`: new environment variable end to end.
- `.claude/skills/document-change`: change record template.
- `readme.md`: "Documentation" section pointing to `docs/` and `AGENTS.md`.

## Decisions

- `AGENTS.md` canonical, `CLAUDE.md` imports it: one source for all agents.
- No `release` skill: a release is only a tag push, handled by CI.
- `readme.md` kept lowercase; not renamed (out of scope).

## Usage / Verification

```bash
python3 -m json.tool .claude/settings.json
shellcheck docker-entrypoint.sh
ls docs docs/changes .claude/skills
```

## Follow-ups

- Missing standard files: `.editorconfig`, `Makefile` (build/test/tag
  targets), `CHANGELOG.md`, `CONTRIBUTING.md`, `.pre-commit-config.yaml`,
  `README.md` (only lowercase `readme.md` exists), `README.de.md`,
  `.gitignore`, `.dockerignore`, `LICENSE`.
- `readme.md` links to `github.com/soulofsorrow/docker-smtp/blob/master/Dockerfile`
  and names image `ghcr.io/soulofsorrow/docker-smtp:latest`; the repository
  is `exim4-smtp`, the file is `dockerfile` on `main`, and the Gitea workflow
  publishes to the Gitea registry. Verify and fix the references.
- `docker-compose.yml` uses the same `ghcr.io/soulofsorrow/docker-smtp` image.
- Gitea workflow downloads `hadolint` from `releases/latest` (unpinned) and
  GitHub workflow uses `ludeeus/action-shellcheck@master` (unpinned).
- No healthcheck, no persistent mail queue volume.
