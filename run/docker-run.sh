#!/bin/bash
APP=gerbera
IMAGE=ppamo/gerbera-develop:v1.9.0
ROOT=$(git rev-parse --show-toplevel)
CONFIG=$ROOT/config

CONTAINER=$(docker ps -q --filter name=$APP)
if [ -n "$CONTAINER" ]
then
	echo "* Stoping old container"
	docker stop $APP
fi

echo "* Creating new container"
docker run -d --rm --name $APP \
	--network host \
	-v $CONFIG/config.xml:/var/run/gerbera/config.xml \
	-v $ROOT/scripts/ppamo/:/opt/gerbera/scripts \
	-v /media/backup/Shorts:/media/shorts \
	-v /media/backup/Series:/media/series \
	-v /media/backup/Movies:/media/movies \
	-v /media/backup/__Movies:/media/review \
	-v /media/backup/Ppamo/mp3:/media/music \
	$IMAGE

if [ $? -eq 0 ]
then
	echo "* Attaching to logs"
	docker logs -f $APP
else
	echo "! Error creating container"
fi
