# hadolint ignore=DL3007
FROM saoyui/s7container-arch:latest

RUN \
  --mount=source=./virenv/main,target=main,type=bind \
  bash main/setup.sh
