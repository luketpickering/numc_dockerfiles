#!/bin/bash
podman build --layers=false --tag picker24/cernlib2005:debian_stretch .
podman tag localhost/picker24/cernlib2005:debian_stretch docker.io/picker24/cernlib2005:debian_stretch
podman tag localhost/picker24/cernlib2005:debian_stretch docker.io/picker24/cernlib2005:latest
