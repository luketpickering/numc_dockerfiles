#!/bin/bash
podman build --layers=false --format=docker --tag picker24/genie_2_12_2:debian_stretch .
podman tag localhost/picker24/genie_2_12_2:debian_stretch docker.io/picker24/genie_2_12_2:debian_stretch
podman tag localhost/picker24/genie_2_12_2:debian_stretch docker.io/picker24/genie_2_12_2:latest