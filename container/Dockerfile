FROM ubuntu:26.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /workspace
WORKDIR /workspace

# ------------------------------------------------------------------------------

COPY ./scripts /tmp/scripts

RUN bash /tmp/scripts/root/__init__.sh

USER adevuser
RUN bash /tmp/scripts/user/__init__.sh

USER root
RUN rm -rf /tmp/scripts

USER adevuser
EXPOSE 22

# ------------------------------------------------------------------------------

FROM base AS final

ENTRYPOINT ["/home/adevuser/bin/skj", "ssh-server"]
