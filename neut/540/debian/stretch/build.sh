#!/bin/bash
podman build --layers=false --tag picker24/neut540:debian_stretch .
podman tag localhost/picker24/neut540:debian_stretch docker.io/picker24/neut540:debian_stretch
podman tag localhost/picker24/neut540:debian_stretch docker.io/picker24/neut540:latest
