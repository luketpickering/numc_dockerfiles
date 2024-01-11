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
                       libzip-devel protobuf-devel protobuf-compiler \
                       boost-devel boost-filesystem tbb-devel hdf5-devel \
                       platform-python-devel python3-numpy \
                       vim nano gdb csh tcsh ed quota patch procmail less tmux task-spooler