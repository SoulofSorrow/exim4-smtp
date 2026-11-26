# Architecture

## Summary

- One container, one process: Exim4 daemon (`exim -bdf -v -q30m`: foreground
  daemon, verbose, queue run every 30 minutes).
- Base image `debian:bookworm-slim`, package `exim4-daemon-light`.
- Exposes `25/tcp`. No volumes, no healthcheck, runs as the image default
  user (root); Exim drops privileges itself.

## File map

| Path | Responsibility |
| --- | --- |
| `dockerfile` | Image definition; copies `docker-entrypoint.sh` to `/usr/local/bin/` |
| `docker-entrypoint.sh` | Translates environment variables into `/etc/exim4/update-exim4.conf.conf`, runs `update-exim4.conf`, then `exec "$@"` |
| `docker-compose.yml` | Example service `mail` with smarthost settings (placeholders) |
| `readme.md` | User docs: usage examples, environment variable table |
| `.gitea/workflows/ci.yml` | Gitea Actions: lint, multi-arch build, push to Gitea registry |
| `.github/workflows/ci.yml` | GitHub Actions: lint, multi-arch build, push to `ghcr.io` |

## Startup flow (`docker-entrypoint.sh`)

1. Defaults: `DC_EXIMCONFIG_CONFIGTYPE=internet`,
   `DC_RELAY_NETS=10.0.0.0/8;172.16.0.0/12;192.168.0.0/16`.
2. `RELAY_HOST` set: config type `satellite`,
   `DC_SMARTHOST=$RELAY_HOST::${RELAY_PORT:-25}`. If `RELAY_USERNAME` and
   `RELAY_PASSWORD` are both set, writes `*:<user>:<password>` to
   `/etc/exim4/passwd.client`.
3. `RELAY_NETS` set: overrides `DC_RELAY_NETS`.
4. Reads `LOCAL_INTERFACES`, `OTHER_HOSTNAMES`, `RELAY_DOMAINS`,
   `HIDE_MAILNAME` (default `true`), `LOCAL_DELIVERY` (default `mail_spool`).
5. Writes `/etc/exim4/update-exim4.conf.conf` with fixed keys
   `dc_readhost=''`, `dc_minimaldns='false'`, `CFILEMODE='644'`,
   `dc_use_split_config='false'`, `dc_mailname_in_oh='true'` plus the values
   above.
6. `MAILNAME` set: writes `/etc/mailname` and appends
   `MAIN_HARDCODE_PRIMARY_HOSTNAME=$MAILNAME`.
7. Runs `update-exim4.conf`, then `exec "$@"` (image `CMD`).

The config is regenerated on every container start; nothing persists between
starts.

## Invariants

- Without `RELAY_HOST` the container delivers directly (`internet`).
- Relaying is only allowed for `RELAY_NETS`; the default is private ranges
  only.
- Entrypoint is POSIX `sh` with `set -e`; a failing `update-exim4.conf`
  stops the container.
- Every value is interpolated inside single quotes into the Debian config
  file.
