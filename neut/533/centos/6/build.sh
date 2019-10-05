#!/bin/bash
podman build --layers=false --format=docker --tag picker24/neut533:centos_6 .
podman tag localhost/picker24/neut533:centos_6 docker.io/picker24/neut533:centos_6
