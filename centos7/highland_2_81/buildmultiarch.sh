#!/bin/bash

set -e
set -x

# docker buildx build . -t picker24/highland_2_81:centos7-aarch64 \
#                        --platform=linux/arm64 --build-arg ND280ARCH=aarch64 \
#                        --load --ssh default
# docker push picker24/highland_2_81:centos7-aarch64

docker buildx build . -t picker24/highland_2_81:centos7-x86_64 \
                       --platform=linux/amd64 --build-arg ND280ARCH=x86_64 \
                       --load --ssh default
# docker push picker24/highland_2_81:centos7-x86_64

# docker manifest rm picker24/highland_2_81:centos7 || true
# docker manifest create picker24/highland_2_81:centos7 \
#                 --amend picker24/highland_2_81:centos7-aarch64 \
#                 --amend picker24/highland_2_81:centos7-x86_64
# docker manifest push picker24/highland_2_81:centos7
