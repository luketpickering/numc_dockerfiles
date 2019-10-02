#!/bin/bash
ISMINARG=""
TAG_STUB=picker24/root_6_12_6

if [ ! -z $1 ] && [ $1 == "ON" ]; then
  ISMINARG="--build-arg ISMINIMAL=ON"
  TAG_STUB=picker24/root_6_12_6_min
fi

sudo docker build --squash ${ISMINARG} \
                  --tag ${TAG_STUB}:debian_stretch .
