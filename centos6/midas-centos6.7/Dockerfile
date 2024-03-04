# syntax=docker/dockerfile:1
FROM picker24/centos:6.7

RUN mkdir -p /var/online

ENV MIDASSYS=/opt/midas
ENV PATH=${PATH}:${MIDASSYS}/bin

ADD midas /opt/midas
WORKDIR /opt/midas
RUN mkdir build && cd build \
  && scl enable devtoolset-4 "cmake .." \
  && scl enable devtoolset-4 "make install -j 8" \
  && cd ../ && rm -r build 

ADD nginx.conf /etc/nginx/
RUN mkdir /run

ADD nd280-puppet-config/modules/daq_fpn/files/qx/ /opt/qx
WORKDIR /opt/qx
RUN yum -y localinstall *.rpm

ADD midas-start /opt/

WORKDIR /
ENTRYPOINT ["/opt/midas-start"]