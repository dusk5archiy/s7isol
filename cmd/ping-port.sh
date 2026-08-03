#!/bin/bash

PORT="${1:-}"

curl -I "http://localhost:$PORT"
