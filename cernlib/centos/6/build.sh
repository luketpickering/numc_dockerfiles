#!/bin/bash
podman build --layers=false --tag picker24/cernlib2005:centos_6 .
podman tag picker24/cernlib2005:centos_6 docker.io/picker24/cernlib2005:centos_6