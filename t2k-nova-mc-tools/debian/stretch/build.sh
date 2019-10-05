#!/bin/bash
if [ ! -z $1 ] && [ "$1" = "rebuild" ]; then
  podman build --no-cache --layers=false --format=docker \
    --tag picker24/t2k-nova-mc-tools:int_build \
    .
fi

podman build --no-cache --layers=false --format=docker -f Dockerfile.final \
  --tag picker24/t2k-nova-mc-tools:debian_stretch \
  .

podman tag localhost/picker24/t2k-nova-mc-tools:debian_stretch docker.io/picker24/t2k-nova-mc-tools:debian_stretch
podman tag localhost/picker24/t2k-nova-mc-tools:debian_stretch docker.io/picker24/t2k-nova-mc-tools:latest
