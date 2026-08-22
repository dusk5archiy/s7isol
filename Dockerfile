FROM ubuntu:26.04 AS base

# Avoid naming CONFIG_USERNAME or CONFIG_PASSWORD
ARG CONFIG_USER_NAME
ARG CONFIG_WORKSPACE
ARG CONFIG_ENV_XDG_RUNTIME_DIR

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

# ------------------------------------------------------------------------------

WORKDIR /tmp

# base/root.sh
RUN \
  --mount=type=bind,source=./docker/base/root.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# ------------------------------------------------------------------------------

USER 1000

# base/user.sh
RUN \
  --mount=type=bind,source=./docker/base/user.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# ==============================================================================

FROM base AS deploy

COPY . "/home/$CONFIG_USER_NAME/s7isol"

RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash "/home/$CONFIG_USER_NAME/s7isol/docker/dev/main.sh"

# ==============================================================================

FROM deploy AS final

RUN \
  --mount=type=bind,source=./setup/main.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# hadolint ignore=DL3059
RUN \
  --mount=type=bind,source=./setup/venv/setup.sh,target=script.sh \
  --mount=type=bind,source=./setup/venv/requirements.txt,target=requirements.txt \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh
