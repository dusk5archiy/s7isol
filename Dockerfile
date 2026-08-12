FROM ubuntu:26.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

# ==============================================================================

ARG CONFIG_USERNAME
ARG CONFIG_WORKSPACE
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

COPY . "/home/$CONFIG_USERNAME/s7isol"

# dev/main.sh
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  --mount=type=bind,source=./setup/dev/main.sh,target=script.sh \
  bash script.sh
