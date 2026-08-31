FROM ubuntu:26.04 AS base

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

# Avoid naming CONFIG_USERNAME or CONFIG_PASSWORD
ARG CONFIG_USER_NAME

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

ARG CONFIG_XDG_RUNTIME_DIR

# dev/init.sh
RUN \
  --mount=type=bind,source=./docker/dev/init.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# programs/wezterm/install.sh
RUN \
  --mount=type=bind,source=./programs/wezterm/install.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# programs/y/install.sh
RUN \
  --mount=type=bind,source=./programs/y/install.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# programs/sound/install.sh
RUN \
  --mount=type=bind,source=./programs/sound/install.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# ------------------------------------------------------------------------------

# programs/vlc/install.sh
RUN \
  --mount=type=bind,source=./programs/vlc/install.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# programs/eog/install.sh
RUN \
  --mount=type=bind,source=./programs/eog/install.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# programs/thunar/install.sh
RUN \
  --mount=type=bind,source=./programs/thunar/install.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# programs/nvim-qt/install.sh
RUN \
  --mount=type=bind,source=./programs/nvim-qt/install.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# scripts/font.sh
RUN \
  --mount=type=bind,source=./scripts/font.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# ------------------------------------------------------------------------------

COPY ./config/nvim "/home/$CONFIG_USER_NAME/s7isol/config/nvim"

RUN \
  --mount=type=bind,source=./programs/nvim,target=nvim \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  S7ISOL="/home/$CONFIG_USER_NAME/s7isol" bash nvim/install.sh

# ------------------------------------------------------------------------------

COPY . "/home/$CONFIG_USER_NAME/s7isol"

RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash "/home/$CONFIG_USER_NAME/s7isol/docker/dev/main.sh"

# ==============================================================================

# hadolint ignore=DL3007
FROM base AS final

# docker/setup.sh
RUN \
  --mount=type=bind,source=./docker/setup.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# docker/virenv/setup.sh
RUN \
  --mount=type=bind,source=./docker/virenv/setup.sh,target=script.sh \
  --mount=type=bind,source=./docker/virenv/requirements.txt,target=requirements.txt \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh
