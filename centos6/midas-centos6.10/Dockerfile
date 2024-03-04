# syntax=docker/dockerfile:1
FROM picker24/centos:6.10

RUN mkdir -p /var/online

ENV MIDASSYS=/opt/midas
ENV PATH=${PATH}:${MIDASSYS}/bin

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan git.t2k.org > ~/.ssh/known_hosts

WORKDIR /opt
RUN git clone https://bitbucket.org/tmidas/midas --recursive \
  && cd /opt/midas \
  && git checkout midas-2022-05-c \
  && git submodule update --init --recursive \
  && mkdir build && cd build \
  && scl enable devtoolset-7 "cmake .." \
  && scl enable devtoolset-7 "make install -j 8" \
  && cd ../ && rm -r build 

ADD nginx.conf /etc/nginx/
RUN mkdir /run

ADD nd280-puppet-config/modules/daq_fpn/files/qx/ /opt/qx
WORKDIR /opt/qx
RUN yum -y localinstall *.rpm

ADD midas-start /opt/

WORKDIR /
ENTRYPOINT ["/opt/midas-start"]