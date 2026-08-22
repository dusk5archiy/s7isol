SHELL:=/bin/bash
MAKEFLAGS += --silent

# [HOST] VS Code ===============================================================

.PHONY: code

code:
	set -euo pipefail && . docker/env.sh && code .

# [HOST] Docker ================================================================

.PHONY: build up start-again down enter clean logs

build:
	set -euo pipefail && . docker/env.sh && docker compose build
up:
	set -euo pipefail && . docker/env.sh && docker compose up -d
start-again:
	set -euo pipefail && . docker/env.sh && docker compose up -d --remove-orphans --force-recreate --build
down:
	set -euo pipefail && . docker/env.sh && docker compose down
enter:
	set -euo pipefail && . docker/env.sh && xhost +local: && docker exec -i "$${CONFIG_PROJECT_NAME}-app-1" /bin/bash -lc "make wezterm"
clean:
	set -euo pipefail && . docker/env.sh && docker compose down -v --rmi all
logs:
	set -euo pipefail && . docker/env.sh && docker logs "$${CONFIG_PROJECT_NAME}-app-1" | less

# ==============================================================================

wezterm:
	bash bin/wezterm.sh

# ------------------------------------------------------------------------------

deploy/build:
	set -euo pipefail && . docker/env.sh adevuser && docker compose -f docker/compose.deploy.yaml build
deploy/push:
	set -euo pipefail && . docker/env.sh adevuser && docker compose -f docker/compose.deploy.yaml push

# ------------------------------------------------------------------------------

init:
	[[ ! -f ".pre.env" ]] && cp example.pre.env .pre.env

# ------------------------------------------------------------------------------

demo:
	. setup/venv/env.sh && python -B main.py demo
ui:
	. setup/venv/env.sh && python -B main.py ui
