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
include src/Makefile
include src_ui/Makefile
include src_wezterm/Makefile
