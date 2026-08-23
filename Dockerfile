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

FROM base AS deploy

ARG CONFIG_WORKSPACE
ARG CONFIG_XDG_RUNTIME_DIR

# ------------------------------------------------------------------------------

# dev/init.sh
RUN \
  --mount=type=bind,source=./docker/dev/init.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# ------------------------------------------------------------------------------

# commands/wezterm/install.sh
RUN \
  --mount=type=bind,source=./commands/wezterm/install.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# commands/yazi/install.sh
RUN \
  --mount=type=bind,source=./commands/yazi/install.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# commands/sound/install.sh
RUN \
  --mount=type=bind,source=./commands/sound/install.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# ------------------------------------------------------------------------------

# commands/vlc/install.sh
RUN \
  --mount=type=bind,source=./commands/vlc/install.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# commands/eog/install.sh
RUN \
  --mount=type=bind,source=./commands/eog/install.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# commands/thunar/install.sh
RUN \
  --mount=type=bind,source=./commands/thunar/install.sh,target=script.sh \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash script.sh

# commands/nvim-qt/install.sh
RUN \
  --mount=type=bind,source=./commands/nvim-qt/install.sh,target=script.sh \
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

COPY . "/home/$CONFIG_USER_NAME/s7isol"

RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
  bash "/home/$CONFIG_USER_NAME/s7isol/docker/dev/main.sh"
