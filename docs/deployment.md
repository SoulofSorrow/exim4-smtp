# Deployment

## Image

- Built from `dockerfile` with context `.`.
- Platforms: `linux/amd64`, `linux/arm64` (QEMU + Buildx).

## CI workflows

Job order: the check jobs (`lint`) run first. The image job `build-and-push` has `needs: [lint]` and starts only when all of them pass; on pull requests it builds without pushing.

Emulation: `docker/setup-qemu-action` is pinned to `tonistiigi/binfmt:qemu-v9.2.2`; with `latest` (QEMU 10) Node crashed with `Illegal instruction` in the arm64 build and the job hung. Job `build-and-push` has `timeout-minutes: 45`.

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

| Event | Image tags |
| --- | --- |
| Push to a branch (e.g. `main`), manual run | `sha-<short>` only |
| Release tag `v1.2.3` | `1.2.3`, `latest`, `sha-<short>` |
| Prerelease tag `v1.2.3-rc1` | `1.2.3-rc1`, `sha-<short>` |
| Pull request | built, not pushed |

## Release

- No release script. A pushed tag `vX.Y.Z` triggers both workflows and
  publishes the semver tags. No tags exist in the repository yet.

## Running

`docker-compose.yml` is an example with service `mail`, image
`ghcr.io/soulofsorrow/docker-smtp:latest`, port binding
`192.168.178.39:25:25` and placeholder credentials. Adjust before use.
