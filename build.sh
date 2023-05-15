#!/bin/sh

[ -L "$0" ] && SCRIPT_FILE=$(readlink -f "$0") && SCRIPT_DIR=$(dirname "$SCRIPT_FILE")
[ ! -L "$0" ] && SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd) && SCRIPT_FILE="$SCRIPT_DIR/$(basename "$0")"
. "$SCRIPT_DIR/common.sh"

#BUILD_CONFIG_FILE="$SCRIPT_DIR/$BUILD_CONFIG_FILE"
#if [ ! -f "$BUILD_CONFIG_FILE" ]; then
#  echo "LOCAL_TNS_ADMIN=" >> "$BUILD_CONFIG_FILE"
#fi

HOST_USER_NAME=$(id -un)
HOST_UID=$(id -u)
HOST_GID=$(id -g)

DOCKER_CLI_EXPERIMENTAL=enabled \
  docker buildx build \
  --platform "$IMAGE_PLATFORM" \
  -t "$IMAGE_NAME:$IMAGE_TAG" \
  --build-arg USER_NAME=$HOST_USER_NAME \
  --build-arg UID=$HOST_UID \
  --build-arg NLS_LANG_ARG=$NLS_LANG \
  --load \
  "$@" \
  .