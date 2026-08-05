#!/bin/bash

source cmd/docker/env.sh
sudo docker compose -p "$CONFIG_PROJECT_NAME" down -v
