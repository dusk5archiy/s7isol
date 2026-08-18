FROM ubuntu:26.04 AS base

ARG CONFIG_USERNAME
ARG CONFIG_WORKSPACE
ARG CONFIG_ENV_XDG_RUNTIME_DIR

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

# ==============================================================================

WORKDIR /tmp

# base/root.sh
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  --mount=type=bind,source=./setup/base/root.sh,target=script.sh \
  bash script.sh

# ==============================================================================

USER 1000

# base/user.sh
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  --mount=type=bind,source=./setup/base/user.sh,target=script.sh \
  bash script.sh

# ==============================================================================

FROM base AS dev

# dev/main.sh
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  --mount=type=bind,source=.,target=/home/$CONFIG_USERNAME/s7isol \
  --mount=type=bind,source=./setup/dev/main.sh,target=script.sh \
  bash script.sh
