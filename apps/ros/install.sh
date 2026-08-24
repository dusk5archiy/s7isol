#!/bin/bash
set -euo pipefail

# Prerequisites: Ubuntu 26.04 LTS
# Target: ROS 2 Lyrical (LTS)

# ------------------------------------------------------------------------------

ROS_DISTRO=${1:-lyrical}

# ------------------------------------------------------------------------------

locale # check for UTF-8
sudo apt-get install -y --no-install-recommends locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
locale # verify settings

# ------------------------------------------------------------------------------

sudo apt-get install -y --no-install-recommends software-properties-common
sudo add-apt-repository universe -y

# ------------------------------------------------------------------------------

sudo apt-get update
sudo apt-get install -y --no-install-recommends curl
ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F'"' '{print $4}')
export ROS_APT_SOURCE_VERSION
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"
sudo dpkg -i /tmp/ros2-apt-source.deb

# ------------------------------------------------------------------------------

sudo apt-get update
sudo apt-get upgrade -y

# ------------------------------------------------------------------------------

sudo apt-get install -y --no-install-recommends \
  "ros-$ROS_DISTRO-desktop" \
  "ros-$ROS_DISTRO-ros-gz" \
  "ros-$ROS_DISTRO-ros-gz-bridge"
