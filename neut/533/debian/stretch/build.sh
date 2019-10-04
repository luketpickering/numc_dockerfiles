#!/bin/bash
podman build --layers=false --tag picker24/neut533:debian_stretch .
podman tag localhost/picker24/neut533:debian_stretch docker.io/picker24/neut533:debian_stretch
podman tag localhost/picker24/neut533:debian_stretch docker.io/picker24/neut533:latest