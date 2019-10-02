#!/bin/bash
ISMIN=OFF
TAG_STUB=picker24/root_6_12_6

if [ ! -z $1 ] && [ $1 == "ON" ]; then
  ISMIN=ON
  TAG_STUB=picker24/root_6_12_6_min
fi

sudo docker build --squash --build-arg ISMINIMAL=${ISMIN} \
                  --tag ${TAG_STUB}:debian_stretch .
