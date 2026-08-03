#!/bin/bash

sudo npx @devcontainers/cli up --workspace-folder .
sudo npx @devcontainers/cli exec --workspace-folder . bash
