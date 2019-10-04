#!/bin/bash
podman build --layers=false --tag picker24/genie_3_00_06:debian_stretch .
podman tag localhost/picker24/genie_3_00_06:debian_stretch docker.io/picker24/genie_3_00_06:debian_stretch
podman tag localhost/picker24/genie_3_00_06:debian_stretch docker.io/picker24/genie_3_00_06:latest