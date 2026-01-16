#!/bin/bash

set -e
set -x

ROOT_VERSION=v6-30-08
ROOT_VERSION_US=$(echo ${ROOT_VERSION} | tr "-" "_")

#better to build them sequentially to give the slow/emulated one more cores

docker buildx build . -t picker24/root_${ROOT_VERSION_US}:alma9-x86_64 \
                       --platform=linux/amd64 \
                       --load --ssh default --build-arg ROOT_VERSION=${ROOT_VERSION} --build-arg NCORES=8
docker push picker24/root_${ROOT_VERSION_US}:alma9-x86_64

docker buildx build . -t picker24/root_${ROOT_VERSION_US}:alma9-aarch64 \
                       --platform=linux/arm64 \
                       --load --ssh default --build-arg ROOT_VERSION=${ROOT_VERSION} --build-arg NCORES=8
docker push picker24/root_${ROOT_VERSION_US}:alma9-aarch64

docker manifest rm picker24/root_${ROOT_VERSION_US}:alma9 || true
docker manifest create picker24/root_${ROOT_VERSION_US}:alma9 \
                --amend picker24/root_${ROOT_VERSION_US}:alma9-aarch64 \
                --amend picker24/root_${ROOT_VERSION_US}:alma9-x86_64
docker manifest push picker24/root_${ROOT_VERSION_US}:alma9
