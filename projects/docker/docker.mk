# Docker -----------------------------------------------------------------------
.PHONY: build
docker-build: # Args=--no-cache
	 . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml build ${Args}
.PHONY: up
docker-up: # Args=--remove-orphans
	 . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml up -d ${Args}
.PHONY: down
docker-down:
	 . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml down
.PHONY: clean
docker-clean:
	 . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml down -v --rmi all
.PHONY: wezterm
docker-wezterm:
	 . docker/env.sh && xhost +local: && docker exec -i "$${CONFIG_PROJECT_NAME}-app-1" /bin/bash -lc "bash cmd/wezterm.sh"
.PHONY: bash
docker-bash:
	 . docker/env.sh && xhost +local: && docker exec -it "$${CONFIG_PROJECT_NAME}-app-1" /bin/bash -l
.PHONY: logs
docker-logs:
	 . docker/env.sh && docker logs "$${CONFIG_PROJECT_NAME}-app-1" | less

