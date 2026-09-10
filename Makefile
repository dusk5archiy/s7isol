include $(Root)docker/docker.mk

.PHONY: push
push:
	set -euo pipefail && . docker/env.sh && docker compose --project-directory . -f docker/compose.yaml push
.PHONY: init
init:
	[[ ! -f .pre.env ]] && cp example.pre.env .pre.env
