#!/bin/bash
podman build --layers=false \
  --tag picker24/novarwgt_v00.23:debian_stretch \
  .
