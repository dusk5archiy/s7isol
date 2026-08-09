FROM ubuntu:26.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------------------------

RUN --mount=from=scripts,target=/tmp/scripts \
  cd /tmp && \
  bash scripts/packages.sh && \
  bash scripts/user.sh

USER adevuser

RUN --mount=from=scripts,target=/tmp/scripts \
  cd /tmp && \
  bash scripts/s7isol.sh

RUN mkdir -p "/home/adevuser/workspace"
WORKDIR "/home/adevuser/workspace"

# ------------------------------------------------------------------------------

FROM base AS dev

RUN --mount=from=scripts,target=/tmp/scripts \
  cd /tmp && \
  bash scripts/dev.sh

# ------------------------------------------------------------------------------

FROM dev AS final

RUN --mount=from=scripts,target=/tmp/scripts \
  cd /tmp && \
  bash scripts/final.sh

ENTRYPOINT ["/home/adevuser/bin/skj", "ssh-server"]
