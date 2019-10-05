FROM debian:stretch-slim

ENV N_CORE=4

ARG BUILD_SW="build-essential gfortran cmake automake libtool pkg-config xutils-dev"
ARG BUILD_LIBS="libgmp3-dev libxml2-dev libgsl-dev liblog4cpp5-dev libbz2-dev libpcre3-dev liblzma-dev zlib1g-dev libfreetype6-dev libssl-dev libfftw3-dev"
ARG BUILD_XLIBS="libx11-dev libxpm-dev libxft-dev libxext-dev libglu1-mesa-dev libglew-dev libftgl-dev libxt-dev libmotif-dev libpng-dev libjpeg-dev"
ARG RETREVAL_SW="git wget subversion"
ARG MISC_SW="vim nano gdb csh tcsh ed quota python-dev"

RUN apt update && apt install --no-install-recommends -y \
  ${BUILD_SW} \
  ${BUILD_LIBS} \
  ${BUILD_XLIBS} \
  ${RETREVAL_SW} \
  ${MISC_SW}

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
