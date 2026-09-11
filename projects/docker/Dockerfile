# hadolint ignore=DL3007
FROM saoyui/s7container-arch:latest

RUN --mount=source=./virenv/setup.sh,target=script.sh,type=bind bash script.sh
RUN --mount=source=./virenv/s7isol,target=s7isol,type=bind bash s7isol/env.sh --setup
