#!/bin/sh

[ -L "$0" ] && SCRIPT_FILE=$(readlink -f "$0") && SCRIPT_DIR=$(dirname "$SCRIPT_FILE")
[ ! -L "$0" ] && SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd) && SCRIPT_FILE="$SCRIPT_DIR/$(basename "$0")"
. "$SCRIPT_DIR/common.sh"

LOCAL_TNS_ADMIN="${LOCAL_TNS_ADMIN:-$TNS_ADMIN}"
[ -z "$LOCAL_TNS_ADMIN" ] && echo "Please, specify 'LOCAL_TNS_ADMIN' parameter in 'common.sh'" >&2 && exit 1

[ -z "$( docker images -q "$IMAGE_NAME:$IMAGE_TAG" )" ] \
  && echo "Docker image [$IMAGE_NAME:$IMAGE_TAG] not found; please, run command 'make build' first" >&2 && exit 1

ORA2PG_RUN_FLAG_INTERACTIVE=${ORA2PG_RUN_FLAG_INTERACTIVE:-"true"}
docker run $( [ ${ORA2PG_RUN_FLAG_INTERACTIVE} = "true" ] && echo "-it" ) \
       --rm \
       --platform ${IMAGE_PLATFORM} \
       -e PG_VERSION=${PG_VERSION} \
       -e CONFIG_LOCATION=${CONFIG_LOCATION} \
       -e OUTPUT_LOCATION=${OUTPUT_LOCATION} \
       -e ORA_HOST=${ORA_HOST} \
       -e ORA_USER=${ORA_USER} \
       -e ORA_PWD=${ORA_PWD} \
       -v ${CONFIG_DIR}:/config \
       -v ${OUTPUT_LOCATION}:/data \
       -v "$(pwd)":/work \
       -v ${LOCAL_TNS_ADMIN}:/etc/oracle/instantclient/network/admin:Z,ro \
       "$IMAGE_NAME:$IMAGE_TAG" \
       bash