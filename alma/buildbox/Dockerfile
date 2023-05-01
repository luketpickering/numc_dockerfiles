# syntax=docker/dockerfile:1
FROM almalinux/9-base AS ts_build
WORKDIR /
RUN dnf -y update
RUN dnf -y install gcc wget ca-certificates

WORKDIR /opt
RUN wget https://vicerveza.homeunix.net/~viric/soft/ts/ts-1.0.2.tar.gz
RUN tar -zxvf ts-1.0.2.tar.gz
WORKDIR /opt/ts-1.0.2
RUN make

FROM almalinux/9-base

COPY --from=ts_build /opt/ts-1.0.2/ts /usr/local/bin/

RUN dnf -y update \
    && dnf -y install dnf-plugins-core ca-certificates \
    && dnf config-manager --set-enabled crb \
    && dnf -y install epel-release \
    && dnf -y update \
    && dnf -y install  gcc gcc-c++ gcc-gfortran cmake3 make imake autoconf automake pkgconfig libtool \
                       git wget subversion openssh-clients openssl-devel bzip2 cvs \
                       xorg-x11-utils \
                       libXt-devel libXpm-devel libXft-devel libXext-devel libAfterImage-devel graphviz-devel \
                       libuuid-devel xrootd-client-devel xrootd-devel xrootd-server-devel krb5-devel \
                       mesa-libGLU-devel mesa-libGLw glew-devel motif-devel libpng-devel libjpeg-turbo-devel ftgl-devel \
                       libxml2-devel gmp-devel gsl-devel log4cpp-devel bzip2-devel pcre-devel xz-devel zlib-devel \
                       freetype-devel fftw-devel blas-devel lapack-devel lz4-devel z3-devel xz-devel libnsl2-devel \
                       libzip-devel protobuf-c-devel protobuf-compiler \
                       boost-devel boost-filesystem tbb-devel \
                       platform-python-devel python3-numpy \
                       vim nano gdb csh tcsh ed quota patch procmail less tmux