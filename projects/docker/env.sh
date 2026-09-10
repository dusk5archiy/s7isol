# shellcheck source=/dev/null
# Arguments --------------------------------------------------------------------
BaseName=$(basename "$PWD" | tr '[:upper:]' '[:lower:]')
export CONFIG_PROJECT_NAME=$BaseName
export CONFIG_DOCKERFILE=$PWD/docker/Dockerfile

export BUILDX_NO_DEFAULT_ATTESTATIONS=1
export CONFIG_CONTEXT=$PWD
export CONFIG_MOUNT_FALLBACK=/dev/null:/dev/null
export CONFIG_ENV_FALLBACK=_=

# Workspace --------------------------------------------------------------------
FromWorkspace=$CONFIG_CONTEXT
ToWorkspace=/home/$CONFIG_USER_NAME/workspace
export CONFIG_WORKSPACE=$ToWorkspace
export CONFIG_MOUNT_WORKSPACE=$FromWorkspace:$ToWorkspace

# ==============================================================================
Dir=$(dirname "${BASH_SOURCE[0]}")
if File=$Dir/env/ide.sh && [[ -f $File ]]; then . "$File"; fi
if File=$Dir/env/gui.sh && [[ -f $File ]]; then . "$File"; fi
