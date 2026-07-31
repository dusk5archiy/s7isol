#!/bin/bash

set -euo pipefail

sudo ssh-keygen -A
exec sudo /usr/sbin/sshd -D
