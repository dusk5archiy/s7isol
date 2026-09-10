# Docker -----------------------------------------------------------------------
.PHONY: build
build: # Args=--no-cache
	 . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml build ${Args}
.PHONY: up
up: # Args=--remove-orphans
	 . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml up -d ${Args}
.PHONY: down
down:
	 . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml down
.PHONY: clean
clean:
	 . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml down -v --rmi all
.PHONY: wezterm
wezterm:
	 . docker/env.sh && xhost +local: && docker exec -i "$${CONFIG_PROJECT_NAME}-app-1" /bin/bash -lc "bash cmd/wezterm.sh"
.PHONY: bash
bash:
	 . docker/env.sh && xhost +local: && docker exec -it "$${CONFIG_PROJECT_NAME}-app-1" /bin/bash -l
.PHONY: logs
logs:
	 . docker/env.sh && docker logs "$${CONFIG_PROJECT_NAME}-app-1" | less

