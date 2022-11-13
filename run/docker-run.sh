#!/bin/bash
APP=gerbera
IMAGE=ppamo-gerbera-develop:v1.9.2
ROOT=$(git rev-parse --show-toplevel)
CONFIG=$ROOT/config

CONTAINER=$(docker ps -q --filter name=$APP)
if [ -n "$CONTAINER" ]
then
	echo "* Stoping old container"
	docker stop $APP
fi

echo "* Creating new container"
docker run -ti --rm --name $APP \
	--network host \
	-v $CONFIG/config.xml:/var/run/gerbera/config.xml \
	-v $ROOT/scripts/ppamo/:/opt/gerbera/scripts \
	-v /Volumes/Backups/Shorts:/media/shorts \
	-v /Volumes/Backups/Series:/media/series \
	-v /Volumes/Backups/Movies:/media/movies \
	-v /Volumes/Backups/__Movies:/media/review \
	-v /Volumes/Backups/Ppamo/mp3:/media/music \
	-v $PWD/run/config.xml:/run/gerbera/config.xml \
	-v $PWD/run/gerbera.db:/run/gerbera/gerbera.db \
	$IMAGE

if [ $? -eq 0 ]
then
	echo "* Attaching to logs"
	docker logs -f $APP
else
	echo "! Error creating container"
fi
