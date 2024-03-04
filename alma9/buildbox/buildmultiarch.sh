#!/bin/bash

set -e
set -x

#better to build them sequentially to give the slow/emulated one more cores

docker buildx build . -t picker24/buildbox:alma9-aarch64 \
                       --platform=linux/arm64 \
                       --load --build-arg NUMC_BUILD_ARCH=aarch64 \
                       --no-cache
docker push picker24/buildbox:alma9-aarch64

docker buildx build . -t picker24/buildbox:alma9-x86_64 \
                       --platform=linux/amd64 \
                       --load --build-arg NUMC_BUILD_ARCH=x86_64 \
                       --no-cache
docker push picker24/buildbox:alma9-x86_64

docker manifest rm picker24/buildbox:alma9 || true
docker manifest create picker24/buildbox:alma9 \
                --amend picker24/buildbox:alma9-aarch64 \
                --amend picker24/buildbox:alma9-x86_64
docker manifest push picker24/buildbox:alma9
