#!/bin/bash

export DOCKER_DEFAULT_PLATFORM=linux/amd64


if [ -z "$1" ]
then
      echo "No arguments"
      exit 1
fi
COMMAND=$1

case $COMMAND in
    build)
        pushd ./docker
        docker buildx build --platform linux/amd64 -t prasanthmj/pgclient:latest -t prasanthmj/pgclient:1.0.8 . --load
        popd
    ;;
    push)
        docker push prasanthmj/pgclient -a
    ;;
esac


