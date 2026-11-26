# Deployment

## Image

- Built from `dockerfile` with context `.`.
- Platforms: `linux/amd64`, `linux/arm64` (QEMU + Buildx).

## CI workflows

Both workflows have the same triggers: `push` to `main`, tags `v*.*.*`,
`pull_request` to `main`, `workflow_dispatch`. Both have jobs `lint` and
`build-and-push`. Pull requests build only; push and login happen only when
`github.event_name != 'pull_request'`.

| | `.gitea/workflows/ci.yml` | `.github/workflows/ci.yml` |
| --- | --- | --- |
| Registry | `vars.REGISTRY_GITEA`, default `gitea.groot.rocks` | `ghcr.io` |
| Image name | `<registry>/<owner>/<repo>` (`github.repository`) | same |
| Lint | `shellcheck docker-entrypoint.sh`, `hadolint dockerfile` (installed in the job, container `catthehacker/ubuntu:act-latest`) | `ludeeus/action-shellcheck@master`, `hadolint/hadolint-action@v3.1.0` |
| Docker | `docker:27-dind` service, `DOCKER_HOST=tcp://dind:2375`, Buildx `network=host` | hosted runner, GHA cache |
| Login | `secrets.GITEA_USERNAME` or `github.actor`; `secrets.PACKAGES_TOKEN` (user-level secret) | `github.actor`, `secrets.GITHUB_TOKEN` |

## Image tags (`docker/metadata-action@v5`)

| Rule | Example |
| --- | --- |
| `type=ref,event=branch` | `main` |
| `type=ref,event=pr` | `pr-12` |
| `type=semver,pattern={{version}}` | `1.2.3` |
| `type=semver,pattern={{major}}.{{minor}}` | `1.2` |
| `type=sha` | `sha-<short>` |
| `type=raw,value=latest,enable={{is_default_branch}}` | `latest` |

## Release

- No release script. A pushed tag `vX.Y.Z` triggers both workflows and
  publishes the semver tags. No tags exist in the repository yet.

## Running

`docker-compose.yml` is an example with service `mail`, image
`ghcr.io/soulofsorrow/docker-smtp:latest`, port binding
`192.168.178.39:25:25` and placeholder credentials. Adjust before use.
