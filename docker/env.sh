. projects/docker/env.sh

# ------------------------------------------------------------------------------

DefaultOs=arch
ConfigOs=${CONFIG_OS:-$DefaultOs}
case $ConfigOs in
ubuntu | arch)
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac
echo "Os: $ConfigOs"

# ------------------------------------------------------------------------------

BaseName=$(basename "$PWD" | tr '[:upper:]' '[:lower:]')
CONFIG_PROJECT_NAME=$BaseName
case $ConfigOs in
arch)
  CONFIG_PROJECT_NAME=${BaseName}_arch
  ;;
esac

case $ConfigOs in
ubuntu)
  CONFIG_IMAGE=saoyui/s7container-base:latest
  CONFIG_DOCKERFILE=$PWD/docker/Dockerfile.ubuntu
  ;;
arch)
  CONFIG_IMAGE=saoyui/s7container-arch:latest
  CONFIG_DOCKERFILE=$PWD/docker/Dockerfile.arch
  ;;
esac

export CONFIG_PROJECT_NAME CONFIG_IMAGE CONFIG_DOCKERFILE

# ------------------------------------------------------------------------------

export CONFIG_MOUNT_S7ISOL=$FROM_WORKSPACE:"/home/$CONFIG_USER_NAME/s7isol"
