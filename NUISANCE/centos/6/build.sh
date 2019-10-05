#!/bin/bash
podman build --layers=false --format=docker \
  --tag picker24/nuisance:centos_6 \
  .
podman tag localhost/picker24/nuisance:centos_6 docker.io/picker24/nuisance:centos_6