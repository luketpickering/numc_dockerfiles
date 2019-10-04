#!/bin/bash
podman build --no-cache --layers=false \
  --tag picker24/t2k-nova-mc-tools:debian_stretch \
  .
podman tag localhost/picker24/t2k-nova-mc-tools:debian_stretch docker.io/picker24/t2k-nova-mc-tools:debian_stretch
podman tag localhost/picker24/t2k-nova-mc-tools:debian_stretch docker.io/picker24/t2k-nova-mc-tools:latest
