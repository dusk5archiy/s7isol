SHELL:=/bin/bash
.PHONY: setup
setup:
	bash setup/docker/run.sh
	bash setup/venv/main/setup.sh

ui:
	. setup/venv/main/env.sh
	python -B main.py ui

run:
	. setup/venv/main/env.sh
	python -B main.py demo
