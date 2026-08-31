SHELL:=/bin/bash
MAKEFLAGS += --silent

# [HOST] VS Code ---------------------------------------------------------------
# Commands to run on the host.

.PHONY: code

code:
	set -euo pipefail && . docker/env.sh && code .

# [HOST] Docker ----------------------------------------------------------------
# Commands to run on the host.

.PHONY: build up start-again down enter clean logs

build:
	set -euo pipefail && . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml build
build-no-cache:
	set -euo pipefail && . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml build --no-cache
up:
	set -euo pipefail && . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml up -d
start-again:
	set -euo pipefail && . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml up -d --remove-orphans --force-recreate
down:
	set -euo pipefail && . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml down
clean:
	set -euo pipefail && . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml down -v --rmi all
wezterm:
	set -euo pipefail && . docker/env.sh && xhost +local: && docker exec -i "$${CONFIG_PROJECT_NAME}-app-1" /bin/bash -lc "bash cmd/wezterm.sh"
bash:
	set -euo pipefail && . docker/env.sh && docker exec -it "$${CONFIG_PROJECT_NAME}-app-1" /bin/bash -l
logs:
	set -euo pipefail && . docker/env.sh && docker logs "$${CONFIG_PROJECT_NAME}-app-1" | less

# ==============================================================================

# S7ISOL -----------------------------------------------------------------------

.PHONY: push
push:
	set -euo pipefail && . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml push
.PHONY: init
init:
	[[ ! -f .pre.env ]] && cp example.pre.env .pre.env
