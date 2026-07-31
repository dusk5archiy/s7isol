#!/bin/bash

set -euo pipefail

sudo apt-get install -y --no-install-recommends apt-transport-https curl gnupg wget
curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg
sudo mv bazel-archive-keyring.gpg /usr/share/keyrings
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list

sudo apt-get update
sudo apt-get install -y --no-install-recommends bazel-7.7.0
sudo cp /usr/bin/bazel-7.7.0 /usr/bin/bazel
