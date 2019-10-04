#!/bin/bash
podman build --layers=false --tag picker24/t2kreweight_v1r27p3:debian_stretch .
podman tag localhost/picker24/t2kreweight_v1r27p3:debian_stretch docker.io/picker24/t2kreweight_v1r27p3:debian_stretch
podman tag localhost/picker24/t2kreweight_v1r27p3:debian_stretch docker.io/picker24/t2kreweight_v1r27p3:latest