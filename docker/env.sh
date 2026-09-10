. projects/docker/env.sh

# ------------------------------------------------------------------------------

DefaultOs=arch
ConfigOs=${CONFIG_OS:-$DefaultOs}
case $ConfigOs in
arch | light) # ubuntu
  ;;
*)
  echo "[-- error --] unsupported platform" >&2
  exit 1
  ;;
esac
echo "Os: $ConfigOs"

# ------------------------------------------------------------------------------

BaseName=$(basename "$PWD" | tr '[:upper:]' '[:lower:]')
CONFIG_PROJECT_NAME=${BaseName}_$ConfigOs
CONFIG_IMAGE=saoyui/s7container-$ConfigOs:latest
CONFIG_DOCKERFILE=$PWD/docker/Dockerfile.$ConfigOs

case $ConfigOs in
ubuntu)
  CONFIG_IMAGE=saoyui/s7container-base:latest
  ;;
arch)
  CONFIG_TARGET=main
  ;;
light)
  CONFIG_DOCKERFILE=$PWD/docker/Dockerfile.arch
  CONFIG_TARGET=light
  ;;
esac

export CONFIG_PROJECT_NAME CONFIG_IMAGE CONFIG_DOCKERFILE CONFIG_TARGET

# ------------------------------------------------------------------------------

FromS7isol=$PWD
ToS7isol=/mnt/s7isol
export CONFIG_MOUNT_S7ISOL=$FromS7isol:$ToS7isol
