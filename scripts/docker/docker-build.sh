#!/bin/bash

APP=$(git remote -v  | grep -E "origin.*(fetch)" | awk '{ print $2 }')
APP=${APP#*//*/}
APP=${APP%.git}
APP=${APP,,}
BRANCH=$(git branch | grep "*" | sed 's/^..//g')
VERSION=$(git tag -l | grep -E '^v.*' | tail -n 1)
IMAGE=$APP-$BRANCH:$VERSION

cd $(git rev-parse --show-toplevel)
if [ ! -f Dockerfile ]
then
	printf 'Archivo Dockerfile no encontrado\n'
	exit 1
fi

printf "Building %s\n" "$IMAGE"

docker images --format "{{.Repository}}:{{.Tag}}" "$IMAGE" | grep "$IMAGE" > /dev/null
if [ $? -eq 0 ]
then
	printf "Image already exists\n"
	exit 0
fi

docker build -t $IMAGE ./
printf 'Done\n'
