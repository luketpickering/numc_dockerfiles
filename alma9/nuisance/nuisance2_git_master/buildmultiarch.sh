#!/bin/bash

set -e
set -x

docker buildx build . -t picker24/nuisance2_git_master:alma9-amd64 \
                       --platform=linux/amd64 \
                       --load --no-cache
docker push picker24/nuisance2_git_master:alma9-amd64

docker buildx build . -t picker24/nuisance2_git_master:alma9-arm64 \
                       --platform=linux/arm64 \
                       --load --no-cache
docker push picker24/nuisance2_git_master:alma9-arm64

docker manifest rm picker24/nuisance2_git_master:alma9 || true
docker manifest create picker24/nuisance2_git_master:alma9 \
                --amend picker24/nuisance2_git_master:alma9-arm64 \
                --amend picker24/nuisance2_git_master:alma9-amd64
docker manifest push picker24/nuisance2_git_master:alma9
