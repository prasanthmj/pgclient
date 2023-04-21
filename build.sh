#!/bin/bash

export DOCKER_DEFAULT_PLATFORM=linux/arm64


if [ -z "$1" ]
then
      echo "No arguments"
      exit 1
fi
COMMAND=$1

case $COMMAND in
    build)
        pushd ./docker
        docker build -t prasanthmj/pgclient:latest -t prasanthmj/pgclient:1.0.8 .
        popd
    ;;
    push)
        docker push prasanthmj/pgclient:latest
    ;;
esac


