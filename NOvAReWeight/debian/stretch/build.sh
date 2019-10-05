#!/bin/bash
podman build --layers=false --format=docker \
  --tag picker24/novarwgt_v00.23:latest \
  .
