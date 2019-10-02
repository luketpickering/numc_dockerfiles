#!/bin/bash
sudo docker build --squash \
  --tag picker24/nuisance:debian_stretch \
  .