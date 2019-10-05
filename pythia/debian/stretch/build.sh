#!/bin/bash
podman build --layers=false --format=docker --tag picker24/pythia6_4_28:debian_stretch .
podman tag localhost/picker24/pythia6_4_28:debian_stretch docker.io/picker24/pythia6_4_28:debian_stretch
podman tag localhost/picker24/pythia6_4_28:debian_stretch docker.io/picker24/pythia6_4_28:latest
