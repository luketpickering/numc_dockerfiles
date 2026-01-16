# syntax=docker/dockerfile:1
FROM picker24/buildbox:alma9
WORKDIR /

RUN mkdir -p /var/online

ENV MIDASSYS=/opt/midas
ENV PATH=${PATH}:${MIDASSYS}/bin

WORKDIR /opt
RUN git clone https://bitbucket.org/tmidas/midas --recursive \
  && cd /opt/midas \
  && git checkout --recurse-submodules midas-2022-05-c \
  && mkdir build && cd build \
  && cmake .. \
  && make install -j 8 \
  && cd ../ && rm -r build 