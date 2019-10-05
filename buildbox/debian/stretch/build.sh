#!/bin/bash

podman build --layers=false --format=docker \
             --tag picker24/buildbox:debian_stretch .
podman tag localhost/picker24/buildbox:debian_stretch docker.io/picker24/buildbox:debian_stretch
podman tag localhost/picker24/buildbox:debian_stretch docker.io/picker24/buildbox:latest