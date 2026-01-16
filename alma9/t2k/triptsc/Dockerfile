# syntax=docker/dockerfile:1
# ARG BUILDARCH
# FROM git.t2k.org:8088/daq/midas:nd280_alma9_${BUILDARCH}
FROM picker24/midas-nd280gsc:alma9
WORKDIR /

WORKDIR /opt/

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan git.t2k.org > ~/.ssh/known_hosts

RUN --mount=type=ssh git clone git@git.t2k.org:daq/t2k-slow-control.git t2k-slow-control-build
RUN cd /opt/t2k-slow-control-build && git checkout feature/newmidas-cmakify \
  && mkdir build && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/opt/t2k-slow-control \
  && make install -j 8 && cd / && rm -r /opt/t2k-slow-control-build

ENV PATH=/opt/t2k-slow-control/midas/frontend:/opt/t2k-slow-control/midas/frontend/scripts:${PATH}

ENV TRIPTSC_CUSTOM_ROOT=/opt/t2k-slow-control/midas/custom

ADD midas-start /opt/

ENTRYPOINT ["/opt/midas-start"]