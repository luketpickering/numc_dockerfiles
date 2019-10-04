#!/bin/bash
BUILD_MINIMAL="OFF"
BUILD_MAXIMAL="ON"

TRANSIENT_SW="build-essential gfortran cmake git python-dev wget libpcre3-dev liblzma-dev zlib1g-dev libgsl-dev libfreetype6-dev libx11-dev libxpm-dev libxft-dev libxext-dev libglu1-mesa-dev libglew-dev libftgl-dev libssl-dev libfftw3-dev libpng16-16 libjpeg62-turbo libxml2-dev"

INST_SW="libstdc++-6-dev libgfortran3 libfreetype6 libpcre3 liblzma5 zlib1g libgsl2 libx11-6 libxpm4 libxft2 libxext6 python libglu1-mesa libglew2.0 libftgl2 libssl1.1 libfftw3-3 libxml2"


TAG_STUB=picker24/root_6_12_6

if [ ! -z $1 ] && [ $1 == "ON" ]; then
  
  BUILD_MINIMAL="ON"

  BUILD_MAXIMAL="OFF"

  TRANSIENT_SW="build-essential gfortran python cmake git wget libpcre3-dev liblzma-dev zlib1g-dev libgsl-dev libfreetype6-dev libxml2-dev"

  INST_SW="libstdc++-6-dev python libgfortran3 libfreetype6 libpcre3 liblzma5 zlib1g libgsl2 libx11-6 libxpm4 libxml2"


  TAG_STUB=picker24/root_6_12_6_min
fi

podman build --layers=false \
              --build-arg BUILD_MINIMAL="${BUILD_MINIMAL}" \
              --build-arg BUILD_MAXIMAL="${BUILD_MAXIMAL}" \
              --build-arg TRANSIENT_SW="${TRANSIENT_SW}" \
              --build-arg INST_SW="${INST_SW}" \
             --tag ${TAG_STUB}:debian_stretch .
podman tag localhost/${TAG_STUB}:debian_stretch docker.io/${TAG_STUB}:debian_stretch
podman tag localhost/${TAG_STUB}:debian_stretch docker.io/${TAG_STUB}:latest