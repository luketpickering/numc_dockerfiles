#!/bin/bash
podman build --layers=false --format=docker --tag picker24/gibuu_2019:debian_stretch .
podman tag localhost/picker24/gibuu_2019:debian_stretch  docker.io/picker24/gibuu_2019:debian_stretch
podman tag localhost/picker24/gibuu_2019:debian_stretch  docker.io/picker24/gibuu_2019:latest