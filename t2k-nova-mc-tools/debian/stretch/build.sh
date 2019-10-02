#!/bin/bash
sudo docker build --squash \
  --tag picker24/t2k-nova-mc-tools:debian_stretch \
  .