# syntax=docker/dockerfile:1
FROM picker24/centos:6.7

RUN mkdir -p /var/online

ENV MIDASSYS=/opt/midas
ENV PATH=${PATH}:${MIDASSYS}/linux/bin

ADD midas /opt/midas
ADD mxml /opt/mxml
WORKDIR /opt/midas
RUN make

ADD nginx.conf /etc/nginx/
RUN mkdir /run

ADD nd280-puppet-config/modules/daq_fpn/files/qx/ /opt/qx
WORKDIR /opt/qx
RUN yum -y localinstall *.rpm

ADD midas-start /opt/

WORKDIR /
ENTRYPOINT ["/opt/midas-start"]