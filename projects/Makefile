SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c
MAKEFLAGS += --silent
Root := $(dir $(firstword $(MAKEFILE_LIST)))

include $(Root)docker/docker.mk

.PHONY: code
code:
	. virenv/s7isol/env.sh && code .

# ------------------------------------------------------------------------------

.PHONY: setup
setup:
	bash virenv/s7isol/env.sh --setup

# ------------------------------------------------------------------------------

.PHONY: ui
ui:
	. virenv/s7isol/env.sh && python -B python/main.py ui

.PHONY: wez
wez:
	. virenv/s7isol/env.sh && python -B python/main.py wezterm

.PHONY: demo
demo:
	. virenv/s7isol/env.sh && python -B python/main.py demo
