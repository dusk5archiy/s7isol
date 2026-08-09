#!/bin/bash

source docker/env.sh
sudo docker compose -p "${CONFIG_PROJECT_NAME}" down -v
