# syntax=docker/dockerfile:1

FROM picker24/root_v6_24_06:debian_bullseye-slim as sherpa_build
WORKDIR /

RUN apt install -y libzip-dev libprotobuf-dev protobuf-compiler

RUN mkdir -p /opt/sherpa/{build, 2.3.0}
ADD SHERPA-MC-2.3.0.tar.gz /opt/sherpa/
WORKDIR /opt/sherpa/build

RUN CXXFLAGS=-Wno-narrowing /opt/sherpa/SHERPA-MC-2.3.0/configure --prefix=/opt/sherpa/2.3.0 --enable-ufo
RUN make -j 8 && make install

RUN mkdir -p /opt/hepmc3/{build, git-master}
WORKDIR /opt/hepmc3/
RUN git clone https://gitlab.cern.ch/hepmc/HepMC3.git
WORKDIR /opt/hepmc3/build
RUN cmake /opt/hepmc3/HepMC3 -DHEPMC3_ENABLE_PROTOBUFIO=ON -DCMAKE_INSTALL_PREFIX=/opt/hepmc3/git-master
RUN make -j 8 && make install

FROM picker24/root_v6_24_06:debian_bullseye-slim
WORKDIR /

RUN apt install -y libhdf5-dev libzip4 libprotobuf23 ccache

COPY --from=sherpa_build /opt/sherpa/2.3.0 /opt/sherpa/2.3.0
COPY --from=sherpa_build /opt/hepmc3/git-master /opt/hepmc3/git-master

ENV CMAKE_PREFIX_PATH=/opt/hepmc3/git-master


