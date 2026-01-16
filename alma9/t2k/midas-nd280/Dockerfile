# syntax=docker/dockerfile:1
FROM almalinux/9-base

RUN dnf -y update \
    && dnf -y install dnf-plugins-core ca-certificates \
    && dnf config-manager --set-enabled crb \
    && dnf -y install epel-release \
    && dnf -y update \
    && dnf -y install  gcc gcc-c++ gdb cmake3 pkgconfig libtool \
                       git subversion \
                       libcurl-devel wget openssh-clients openssl-devel libnsl2-devel \
                       libxml2-devel bzip2-devel xz-devel zlib-devel lz4-devel z3-devel libzip-devel \
                       csh tcsh \
                       vim nano ed less patch \
                       procps \
                       nginx httpd-tools netcat net-tools iputils iproute net-snmp-utils

RUN mkdir -p /var/online

ENV MIDASSYS=/opt/midas
ENV PATH=${PATH}:${MIDASSYS}/bin

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan git.t2k.org > ~/.ssh/known_hosts

WORKDIR /opt
RUN --mount=type=ssh git clone --depth 1 --branch nd280-midas-2020-08-a git@git.t2k.org:daq/midas.git --recursive \
  && cd /opt/midas \
  && mkdir build && cd build \
  && cmake ..  \
  && make install -j 8 \
  && cd ../ && rm -r build

ADD nginx.conf /etc/nginx/