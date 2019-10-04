#!/bin/bash
podman build --layers=false --tag picker24/root_5_34_38:centos_6 .
podman tag localhost/picker24/root_5_34_38:centos_6 docker.io/picker24/root_5_34_38:centos_6