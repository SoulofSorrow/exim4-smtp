FROM debian:bookworm-slim

# Install exim4
ENV DEBIAN_FRONTEND=noninteractive
# hadolint ignore=DL3008
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends exim4-daemon-light; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
EXPOSE 25/tcp
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "exim", "-bdf", "-v", "-q30m" ]
