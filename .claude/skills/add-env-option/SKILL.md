---
name: add-env-option
description: Expose another Exim4 Debian configuration option (dc_* key in update-exim4.conf.conf) as an environment variable of the exim4-smtp image. Use when a user wants a new configurable setting.
---

# Add an environment option

Background: `docs/architecture.md` ("Startup flow"), `docs/configuration.md`.

## Steps

1. In `docker-entrypoint.sh`, read the variable with a default:
   `DC_<NAME>="${<VAR>:-<default>}"`, next to the existing blocks, with a one
   line comment.
2. Add the matching line to the heredoc that writes
   `$CONFDIR/update-exim4.conf.conf`, value in single quotes:
   `dc_<key>='$DC_<NAME>'`. If the key is already written with a fixed value
   (`dc_readhost`, `dc_minimaldns`, `dc_use_split_config`,
   `dc_mailname_in_oh`), replace that line instead of adding a duplicate.
3. Keep POSIX `sh`. Run `shellcheck docker-entrypoint.sh`.
4. Add a row to the table in `readme.md` ("Environment variables") and to
   `docs/configuration.md`.
5. Add a commented example to `docker-compose.yml` (placeholder value).
6. Optional local check:
   `docker build -f dockerfile -t exim4-smtp:dev . && docker run --rm -e <VAR>=<value> exim4-smtp:dev cat /etc/exim4/update-exim4.conf.conf`.
7. Run the `document-change` skill.
