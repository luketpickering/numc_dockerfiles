# syntax=docker/dockerfile:1
FROM almalinux/9-base

RUN dnf -y update \
    && dnf -y install dnf-plugins-core ca-certificates \
    && dnf config-manager --set-enabled crb \
    && dnf -y install epel-release \
    && dnf -y update \
    && dnf -y install  gcc gcc-c++ gcc-gfortran cmake3 make imake autoconf automake pkgconfig libtool \
                       git wget subversion openssh-clients openssl-devel bzip2 cvs \
                       xorg-x11-utils \
                       libXt-devel libXpm-devel libXaw-devel libXft-devel libXext-devel libAfterImage-devel graphviz-devel \
                       libuuid-devel xrootd-client-devel xrootd-devel xrootd-server-devel krb5-devel \
                       mesa-libGLU-devel mesa-libGLw glew-devel motif-devel libpng-devel libjpeg-turbo-devel ftgl-devel \
                       libxml2-devel gmp-devel gsl-devel log4cpp-devel bzip2-devel pcre-devel xz-devel zlib-devel \
                       freetype-devel fftw-devel blas-devel lapack-devel lz4-devel z3-devel xz-devel libnsl2-devel \
                       davix-devel \
                       libzip-devel protobuf-devel protobuf-compiler \
                       boost-devel boost-filesystem tbb-devel hdf5-devel sqlite-devel \
                       platform-python-devel python3-numpy \
                       vim nano gdb csh tcsh ed quota patch procmail less tmux task-spooler procps

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:/usr/lib:/usr/lib64:/lib:/lib64

#NUMC_BUILD_ARCH=aarch64
#NUMC_BUILD_ARCH=x86_64
ARG NUMC_BUILD_ARCH=x86_64

ARG CMAKEVERSION=3.28.3

RUN mkdir -p /opt/CMake-build/${CMAKEVERSION} /opt/CMake/${CMAKEVERSION}/ && cd /opt/CMake-build/${CMAKEVERSION} \
  && wget https://github.com/Kitware/CMake/releases/download/v${CMAKEVERSION}/cmake-${CMAKEVERSION}-linux-${NUMC_BUILD_ARCH}.tar.gz \
  && tar -zxf cmake-${CMAKEVERSION}-linux-${NUMC_BUILD_ARCH}.tar.gz \
  && mv /opt/CMake-build/${CMAKEVERSION}/cmake-${CMAKEVERSION}-linux-${NUMC_BUILD_ARCH}/* /opt/CMake/${CMAKEVERSION}/ \
  && rm -r /opt/CMake-build

ENV PATH=/opt/CMake/${CMAKEVERSION}/bin:${PATH}