#!/usr/bin/env bash

function check_env {
    if [ -z "$CONFIG_LOCATION" ]; then
        echo "INFO: No CONFIG_LOCATION variable provided. Using default '/config/ora2pg.conf'"
        export CONFIG_LOCATION=/config/ora2pg.conf
    else
        echo "CONFIG_LOCATION = '$CONFIG_LOCATION'"
    fi

    if [ -z "$OUTPUT_LOCATION" ]; then
        echo "INFO: No OUTPUT_LOCATION variable provided. Using default '/data'"
        export OUTPUT_LOCATION=/data
    else
        echo "OUTPUT_LOCATION = '$OUTPUT_LOCATION'"
        mkdir -p ${OUTPUT_LOCATION}
    fi

    ORA_HOST_FLAG=""
    if [ -z "$ORA_HOST" ]; then
        echo "INFO: No ORA_HOST variable provided. Using value of 'ORACLE_DSN' from '$CONFIG_LOCATION'"
    else
        echo "ORA_HOST_FLAG = '$ORA_HOST'"
        ORA_HOST_FLAG="--source $ORA_HOST"
    fi

    FILE_NAME="$(date +"%d-%m-%Y")"
    ORA_SCHEMA_FLAG=""
    if [ -z "$ORA_SCHEMA" ]; then
        echo "INFO: No ORA_SCHEMA variable provided. Using value of 'SCHEMA' from '$CONFIG_LOCATION'"
    else
        echo "ORA_SCHEMA_FLAG = '$ORA_SCHEMA'"
        ORA_SCHEMA_FLAG="--namespace $ORA_SCHEMA"
        FILE_NAME="$ORA_SCHEMA-$(date +"%d-%m-%Y")"
    fi

    ORA_USER_FLAG=""
    if [ -z "$ORA_USER" ]; then
        echo "INFO: No ORA_USER variable provided. Using value of 'ORACLE_USER' from  '$CONFIG_LOCATION'"
    else
        echo "ORA_USER = '$ORA_USER'"
        ORA_USER_FLAG="--user $ORA_USER"
    fi

    ORA_PWD_FLAG=""
    ORA_PWD_FLAG_MASKED=""
    if [ -z "$ORA_PWD" ]; then
        echo "INFO: No ORA_PWD variable provided. Using value of 'ORACLE_PWD' from  '$CONFIG_LOCATION'"
    else
        echo "ORA_PWD = '*******'"
        ORA_PWD_FLAG="--password $ORA_PWD"
        ORA_PWD_FLAG_MASKED="--password *******"
    fi
}

check_env
ORA_ALL_VAR_4_PRINT="${ORA_HOST_FLAG} ${ORA_SCHEMA_FLAG} ${ORA_USER_FLAG} ${ORA_PWD_FLAG_MASKED}"
ORA_ALL_VAR="${ORA_HOST_FLAG} ${ORA_SCHEMA_FLAG} ${ORA_USER_FLAG} ${ORA_PWD_FLAG}"
if [ "$1" = 'ora2pg' ]; then
    # Set host name for oracle
    #/bin/bash -c "echo '127.0.1.1 ${HOSTNAME}' >> /etc/hosts"
    echo "INFO: Start export"
    echo "ora2pg --debug -c ${CONFIG_LOCATION}"
    echo "       --basedir ${OUTPUT_LOCATION}"
    echo "       -o ${FILE_NAME}.sql"
    echo "       ${ORA_ALL_VAR_4_PRINT}"
    echo "       ${@:2}"
    ora2pg --debug \
           -c ${CONFIG_LOCATION} \
           --basedir ${OUTPUT_LOCATION} \
           -o "${FILE_NAME}.sql" \
           ${ORA_ALL_VAR} \
           ${@:2}
    bash

elif [ "$1" = 'report' ]; then
    echo "INFO: Start report"
    echo "ora2pg -t SHOW_REPORT --estimate_cost --dump_as_html"
    echo "       -c $CONFIG_LOCATION"
    echo "       ${ORA_ALL_VAR_4_PRINT}"
    echo "       ${@:2} > ${OUTPUT_LOCATION}/${FILE_NAME}-report.html"
    ora2pg -t SHOW_REPORT --estimate_cost --dump_as_html \
           -c ${CONFIG_LOCATION} \
           ${ORA_ALL_VAR} \
           ${@:2} > "${OUTPUT_LOCATION}/${FILE_NAME}-report.html"

elif [ "$1" = 'bash' ]; then
  bash
else
  exec "$@"
fi