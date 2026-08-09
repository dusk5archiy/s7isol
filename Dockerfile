FROM ubuntu:26.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------------------------

WORKDIR /tmp

# packages.sh
RUN --mount=type=bind,source=./setup/docker/packages.sh,target=script.sh \
  bash script.sh

# user.sh
RUN --mount=type=bind,source=./setup/docker/user.sh,target=script.sh \
  bash script.sh

# ------------------------------------------------------------------------------

USER 1000

# s7isol.sh
RUN --mount=type=bind,source=./setup/docker/s7isol.sh,target=script.sh \
  bash script.sh

RUN mkdir -p "/home/adevuser/workspace"
WORKDIR "/home/adevuser/workspace"

# ==============================================================================

FROM base AS dev

# dev.sh
RUN --mount=type=bind,source=./setup/docker/dev.sh,target=script.sh \
  bash script.sh

# ==============================================================================

FROM dev AS final

# final.sh
RUN --mount=type=bind,source=./setup/docker/final.sh,target=script.sh \
  bash script.sh

ENTRYPOINT ["/home/adevuser/bin/skj", "ssh-server"]
