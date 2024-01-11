#!/bin/bash

set -e
set -x

#better to build them sequentially to give the slow/emulated one more cores

docker buildx build . -t picker24/root_v6_28_08:alma9-aarch64 \
                       --platform=linux/arm64 \
                       --load --ssh default
docker push picker24/root_v6_28_08:alma9-aarch64

docker buildx build . -t picker24/root_v6_28_08:alma9-x86_64 \
                       --platform=linux/amd64 \
                       --load --ssh default
docker push picker24/root_v6_28_08:alma9-x86_64

docker manifest rm picker24/root_v6_28_08:alma9 || true
docker manifest create picker24/root_v6_28_08:alma9 \
                --amend picker24/root_v6_28_08:alma9-aarch64 \
                --amend picker24/root_v6_28_08:alma9-x86_64
docker manifest push picker24/root_v6_28_08:alma9
