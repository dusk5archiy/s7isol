SHELL:=/bin/bash
build:
	bash docker/cli/build.sh

up:
	bash docker/cli/up.sh

start-again:
	bash docker/cli/up.sh --remove-orphans --force-recreate --build

down:
	bash docker/cli/down.sh

enter:
	bash docker/cli/enter.sh

clean:
	bash docker/cli/clean.sh

logs:
	bash docker/cli/logs.sh

# ------------------------------------------------------------------------------

wezterm:
	bash bin/wezterm.sh

# ------------------------------------------------------------------------------

base/build:
	bash docker/base/build.sh

base/push:
	bash docker/base/push.sh

# ------------------------------------------------------------------------------

init:
	[[ ! -f ".pre.env" ]] && cp example.pre.env .pre.env
