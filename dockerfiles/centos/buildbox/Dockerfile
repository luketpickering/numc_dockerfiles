# syntax=docker/dockerfile:1
FROM centos:7
WORKDIR /
RUN yum -y update && yum -y install epel-release && yum repolist

RUN yum -y install gcc gcc-c++ gcc-gfortran cmake3 make imake autoconf automake pkgconfig libtool
RUN yum -y install git wget subversion openssh-clients openssl-devel bzip2

RUN yum -y install xorg-x11-utils
RUN yum -y install libXt-devel libXpm-devel libXft-devel libXext-devel

RUN yum -y install mesa-libGLU-devel mesa-libGLw glew-devel motif-devel libpng-devel libjpeg-turbo-devel ftgl-devel

RUN yum -y install libxml2-devel gmp-devel gsl-devel log4cpp-devel bzip2-devel pcre-devel xz-devel zlib-devel freetype-devel fftw-devel blas-devel lapack-devel lz4-devel xz-devel

RUN yum -y install vim nano gdb csh tcsh ed quota python-devel patch

ENV TERM xterm-color

RUN sed -i "s/alias/#alias/g" /root/.bashrc
RUN sed -i "s/alias/#alias/g" /root/.cshrc
RUN sed -i "s/alias/#alias/g" /root/.tcshrc

RUN ln -s /usr/bin/cmake3 /usr/bin/cmake