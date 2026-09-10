# AI ---------------------------------------------------------------------------
if [[ -n ${ANTHROPIC_BASE_URL:-} ]]; then export CONFIG_ENV_ANTHROPIC_BASE_URL=ANTHROPIC_BASE_URL=${ANTHROPIC_BASE_URL:-}; fi
if [[ -n ${ANTHROPIC_AUTH_TOKEN:-} ]]; then export CONFIG_ENV_ANTHROPIC_AUTH_TOKEN=ANTHROPIC_AUTH_TOKEN=${ANTHROPIC_AUTH_TOKEN:-}; fi
if [[ -n ${ANTHROPIC_MODEL:-} ]]; then export CONFIG_ENV_ANTHROPIC_MODEL=ANTHROPIC_MODEL=${ANTHROPIC_MODEL:-}; fi

# Claude -----------------------------------------------------------------------
FromClaude=$PWD/docker/.mounts/.claude
ToClaude=/home/$CONFIG_USER_NAME/.claude
if [[ ! -d $FromClaude ]]; then mkdir -p "$FromClaude"; fi
export CONFIG_MOUNT_CLAUDE=$FromClaude:$ToClaude

# Vscode -----------------------------------------------------------------------
FromVscode=$PWD/docker/.mounts/.vscode-server
ToVscode=/home/$CONFIG_USER_NAME/.vscode-server
if [[ ! -d $FromVscode ]]; then mkdir -p "$FromVscode"; fi
export CONFIG_MOUNT_VSCODE=$FromVscode:$ToVscode
