#!/bin/bash
set -e

IN_OPERATION="${1}"
BASE_DIR=$(dirname $(readlink -f "${0}"))
DOCKER_COMPOSE_CONF="${BASE_DIR}/docker-compose.yaml"

source "${BASE_DIR}/env.config"


function init_env () {
#   git -C "${BASE_DIR}" submodule update --init --recursive
   sudo mkdir -p "${VOLUME_PATH}"
   sudo chown 900:900 -R "${VOLUME_PATH}"

  sed -e "s#{{WEB_SERVER_PORT}}#${WEB_SERVER_PORT}#g" \
      -e "s#{{WEB_SERVER_NAME}}#${WEB_SERVER_NAME}#g" \
      "${BASE_DIR}/nginx/nginx.conf.tpl" > "${BASE_DIR}/nginx/nginx.conf"
  echo "Updating nginx.conf"
}

case "${IN_OPERATION}" in

    init)
      init_env
      docker-compose -f "${DOCKER_COMPOSE_CONF}" build
    ;;

    status)
        docker-compose -f "${DOCKER_COMPOSE_CONF}" ps
    ;;

    debug)
        init_env
        docker-compose -f "${DOCKER_COMPOSE_CONF}" up --force-recreate --build
    ;;

    start)
        init_env
        docker-compose -f "${DOCKER_COMPOSE_CONF}" up -d --no-recreate
    ;;

    stop)
        docker-compose -f "${DOCKER_COMPOSE_CONF}" down
    ;;

    clean)
        $0 stop
        docker rmi nginx cgit || true
    ;;

    *)
        cat << EOF
Usage: $0 ACTION

 ACTION:
   init                 [Optional] generate config files,
                        check ssl keys, build required images
   status               get containers status
   debug                run docker-compose in foreground
   start                start all containers in background
   stop                 stop all containers
EOF
        exit 1
    ;;
esac
