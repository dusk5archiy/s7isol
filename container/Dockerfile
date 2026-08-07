FROM ubuntu:26.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------------------------

RUN --mount=type=bind,source=./scripts,target=/tmp/scripts \
  cd /tmp && \
  bash scripts/packages.sh && \
  bash scripts/user.sh

USER adevuser

RUN --mount=type=bind,source=./scripts,target=/tmp/scripts \
  cd /tmp && \
  bash scripts/s7isol.sh

RUN mkdir -p "/home/adevuser/workspace"
WORKDIR "/home/adevuser/workspace"

# ------------------------------------------------------------------------------

FROM base AS dev

RUN --mount=type=bind,source=./scripts,target=/tmp/scripts \
  cd /tmp && \
  bash scripts/extra.sh

# ------------------------------------------------------------------------------

FROM dev AS final

ENTRYPOINT ["/home/adevuser/bin/skj", "ssh-server"]
