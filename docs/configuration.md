# Configuration

All variables are optional. Source of truth: `docker-entrypoint.sh`.
User-facing table: `readme.md`, "Environment variables".

| Variable | Default | Effect |
| --- | --- | --- |
| `MAILNAME` | container hostname (Exim default) | Written to `/etc/mailname`; sets `MAIN_HARDCODE_PRIMARY_HOSTNAME` |
| `RELAY_HOST` | unset | Switches `dc_eximconfig_configtype` to `satellite`; host part of `dc_smarthost` |
| `RELAY_PORT` | `25` | Port part of `dc_smarthost` (`host::port`); only used with `RELAY_HOST` |
| `RELAY_USERNAME` | unset | With `RELAY_PASSWORD`: line in `/etc/exim4/passwd.client`; only used with `RELAY_HOST` |
| `RELAY_PASSWORD` | unset | See `RELAY_USERNAME`. Secret |
| `RELAY_NETS` | `10.0.0.0/8;172.16.0.0/12;192.168.0.0/16` | `dc_relay_nets` |
| `LOCAL_INTERFACES` | empty (all interfaces) | `dc_local_interfaces`, `;` separated |
| `OTHER_HOSTNAMES` | empty | `dc_other_hostnames` |
| `RELAY_DOMAINS` | empty | `dc_relay_domains` |
| `HIDE_MAILNAME` | `true` | `dc_hide_mailname` |
| `LOCAL_DELIVERY` | `mail_spool` | `dc_localdelivery` (`mail_spool`, `maildir_home`, `maildir_directory` per `readme.md`) |

## Secrets

- `RELAY_PASSWORD` is the only secret. Pass it at runtime; never commit it.
- The example values in `docker-compose.yml` and `readme.md` are placeholders.
