SHELL:=/bin/bash
MAKEFLAGS += --silent

# [HOST] VS Code ---------------------------------------------------------------

.PHONY: code

code:
	set -euo pipefail && . docker/env.sh && code .

# [HOST] Docker ----------------------------------------------------------------

.PHONY: build up start-again down enter clean logs

build:
	set -euo pipefail && . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml build
up:
	set -euo pipefail && . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml up -d
start-again:
	set -euo pipefail && . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml up -d --remove-orphans --force-recreate
down:
	set -euo pipefail && . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml down
clean:
	set -euo pipefail && . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml down -v --rmi all
enter:
	set -euo pipefail && . docker/env.sh && xhost +local: && docker exec -i "$${CONFIG_PROJECT_NAME}-app-1" /bin/bash -lc "bash cmd/wezterm.sh"
logs:
	set -euo pipefail && . docker/env.sh && docker logs "$${CONFIG_PROJECT_NAME}-app-1" | less

# ------------------------------------------------------------------------------

.PHONY: demo
demo:
	. virenv/main/env.sh && python -B python/main.py demo
.PHONY: ui
wayland:
	. virenv/main/env.sh && QT_QPA_PLATFORM="wayland" python -B python/main.py ui
x11:
	. virenv/main/env.sh && QT_QPA_PLATFORM="xcb" python -B python/main.py ui
