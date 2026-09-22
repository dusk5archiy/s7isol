SHELL := /bin/bash
MAKEFLAGS += --silent

# ------------------------------------------------------------------------------
Root := $(dir $(firstword $(MAKEFILE_LIST)))

include $(Root)docker/docker.mk

# ------------------------------------------------------------------------------
.PHONY: code
code:
	. virenv/s7isol/env.sh && code .

# ------------------------------------------------------------------------------

.PHONY: setup
setup:
	bash virenv/setup.sh && \
	bash virenv/s7isol/env.sh --setup
 
# ------------------------------------------------------------------------------

.PHONY: wezterm
wezterm:
	. virenv/s7isol/env.sh && python -B -m src_wezterm settings/programs.yaml

.PHONY: main
main:
	. virenv/s7isol/env.sh && python -B -m src
