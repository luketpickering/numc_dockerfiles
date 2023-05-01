# syntax=docker/dockerfile:1
FROM centos:7
WORKDIR /
RUN yum -y update && yum -y install epel-release && yum repolist \
    && yum -y install gcc gcc-c++ gcc-gfortran cmake3 make imake autoconf automake pkgconfig libtool \
                   git wget subversion openssh-clients openssl-devel bzip2 \
                   xorg-x11-utils \
                   libXt-devel libXpm-devel libXft-devel libXext-devel \
                   mesa-libGLU-devel mesa-libGLw glew-devel motif-devel libpng-devel libjpeg-turbo-devel ftgl-devel \
                   libxml2-devel gmp-devel gsl-devel log4cpp-devel bzip2-devel pcre-devel xz-devel zlib-devel freetype-devel fftw-devel blas-devel lapack-devel lz4-devel xz-devel \
                   vim nano gdb csh tcsh ed quota python-devel patch \
                   ca-certificates

ENV TERM xterm-color

RUN sed -i "s/alias/#alias/g" /root/.bashrc \
    && sed -i "s/alias/#alias/g" /root/.cshrc \
    && sed -i "s/alias/#alias/g" /root/.tcshrc \
    && ln -s /usr/bin/cmake3 /usr/bin/cmake