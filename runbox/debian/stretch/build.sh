#!/bin/bash

podman build --layers=false --format=docker \
             --tag picker24/runbox:debian_stretch .
podman tag localhost/picker24/runbox:debian_stretch docker.io/picker24/runbox:debian_stretch
podman tag localhost/picker24/runbox:debian_stretch docker.io/picker24/runbox:latest