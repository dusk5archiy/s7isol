FROM ubuntu:26.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------------------------

WORKDIR /tmp

# packages.sh
RUN --mount=type=bind,source=./docker/setup/packages.sh,target=script.sh \
  bash script.sh

# user.sh
RUN --mount=type=bind,source=./docker/setup/user.sh,target=script.sh \
  bash script.sh

# ------------------------------------------------------------------------------

USER adevuser

# s7isol.sh
RUN --mount=type=bind,source=./docker/setup/s7isol.sh,target=script.sh \
  bash script.sh

RUN mkdir -p "/home/adevuser/workspace"
WORKDIR "/home/adevuser/workspace"

# ==============================================================================

FROM base AS dev

# dev.sh
RUN --mount=type=bind,source=./docker/setup/dev.sh,target=script.sh \
  bash script.sh

# ==============================================================================

FROM dev AS final

# final.sh
RUN --mount=type=bind,source=./docker/setup/final.sh,target=script.sh \
  bash script.sh

ENTRYPOINT ["/home/adevuser/bin/skj", "ssh-server"]

