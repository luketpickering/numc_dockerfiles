# syntax=docker/dockerfile:1
FROM centos:centos6.7

ADD CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
ADD epel.repo /etc/yum.repos.d/epel.repo
ADD CentOS-SCLo-scl.repo /etc/yum.repos.d/CentOS-SCLo-scl.repo
ADD CentOS-SCLo-scl-rh.repo /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo

RUN yum -y update \
    && yum -y install ca-certificates \
    && yum -y install epel-release centos-release-scl \
    && yum -y update
RUN yum -y install  gcc gcc-c++ gdb pkgconfig libtool \
                    git subversion \
                    libcurl-devel wget openssh-clients openssl-devel libnsl2-devel \
                    libxml2-devel bzip2-devel xz-devel zlib-devel lz4-devel libzip-devel zip unzip \
                    csh tcsh \
                    vim nano ed less patch \
                    procps \
                    nginx httpd-tools net-tools iputils iproute net-snmp-utils

RUN yum -y install devtoolset-4-gcc devtoolset-4-gcc-c++ devtoolset-4-gdb devtoolset-4-binutils

RUN yum -y install tar

WORKDIR /
RUN wget https://github.com/Kitware/CMake/releases/download/v3.27.4/cmake-3.27.4-linux-x86_64.tar.gz \
  && tar -zxvf cmake-3.27.4-linux-x86_64.tar.gz \
  && cp -r cmake-3.27.4-linux-x86_64/bin/* /usr/local/bin/ \
  && cp -r cmake-3.27.4-linux-x86_64/share/* /usr/local/share/ \
  && rm -r cmake-3.27.4-linux-x86_64 cmake-3.27.4-linux-x86_64.tar.gz