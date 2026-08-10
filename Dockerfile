FROM ubuntu:26.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------------------------

WORKDIR /tmp

# packages.sh
RUN --mount=type=bind,source=./setup/base/packages.sh,target=script.sh \
  bash script.sh

# user.sh
RUN --mount=type=bind,source=./setup/base/user.sh,target=script.sh \
  bash script.sh

# ------------------------------------------------------------------------------

USER 1000
RUN mkdir -p "/home/adevuser/workspace"
WORKDIR "/home/adevuser/workspace"

# ==============================================================================

FROM base AS dev

# dev/main.sh
RUN --mount=type=bind,source=./setup/dev/main.sh,target=script.sh \
  bash script.sh

# ==============================================================================

FROM dev AS final

# final/main.sh
RUN --mount=type=bind,source=./setup/final/main.sh,target=script.sh \
  bash script.sh

ENTRYPOINT ["/home/adevuser/bin/skj", "ssh-server"]
