# syntax=docker/dockerfile:1
FROM centos:7 as gitupdate
WORKDIR /

RUN yum -y update && yum -y install epel-release && yum repolist \
    && yum -y install gcc gcc-c++ gcc-gfortran cmake3 make autoconf automake pkgconfig libtool \
                   wget openssh-clients openssl-devel \
                   libxml2-devel gmp-devel gsl-devel bzip2-devel pcre-devel xz-devel zlib-devel \
                   freetype-devel lz4-devel xz-devel gettext \
                   ca-certificates libcurl-devel

RUN wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.40.0.tar.gz
RUN tar -zxvf git-2.40.0.tar.gz
WORKDIR /git-2.40.0
RUN ./configure && make install

FROM centos:7
WORKDIR /

RUN yum -y update && yum -y install epel-release && yum repolist \
    && yum -y install gcc gcc-c++ gcc-gfortran cmake3 make imake autoconf automake pkgconfig libtool \
                   wget subversion openssh-clients openssl-devel \
                   xorg-x11-utils \
                   libXt-devel libXpm-devel libXft-devel libXext-devel \
                   mesa-libGLU-devel mesa-libGLw glew-devel motif-devel libpng-devel libjpeg-turbo-devel ftgl-devel \
                   libxml2-devel gmp-devel gsl-devel log4cpp-devel bzip2-devel pcre-devel xz-devel zlib-devel \
                   freetype-devel fftw-devel blas-devel lapack-devel lz4-devel xz-devel \
                   vim nano gdb csh tcsh ed quota python-devel python3-devel patch \
                   ca-certificates ncurses-devel

COPY --from=gitupdate /usr/local /usr/local

ENV TERM xterm-color

RUN sed -i "s/alias/#alias/g" /root/.bashrc \
    && sed -i "s/alias/#alias/g" /root/.cshrc \
    && sed -i "s/alias/#alias/g" /root/.tcshrc \
    && ln -s /usr/bin/cmake3 /usr/bin/cmake