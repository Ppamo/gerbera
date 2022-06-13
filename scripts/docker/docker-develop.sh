#!/bin/bash

BUILDER_NAME=gerbera_build

docker ps --filter "name=$BUILDER_NAME" --format "{{.ID}} - {{.Names}}" | grep -E "^.+ - $BUILDER_NAME$"
if [ $? -eq 0 ]
then
	
	exit 0
fi

echo 2
