# syntax=docker/dockerfile:1

FROM picker24/root_v6_24_06:debian_bullseye-slim as sherpa_build
WORKDIR /

RUN apt install -y libzip-dev libprotobuf-dev protobuf-compiler

ENV SHERPA_VERSION=2.3.0

RUN mkdir -p /opt/sherpa/build /opt/sherpa/${SHERPA_VERSION}
ADD SHERPA-MC-${SHERPA_VERSION}.tar.gz /opt/sherpa/
WORKDIR /opt/sherpa/build

RUN CXXFLAGS=-Wno-narrowing /opt/sherpa/SHERPA-MC-${SHERPA_VERSION}/configure --prefix=/opt/sherpa/${SHERPA_VERSION} --enable-ufo
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

COPY --from=sherpa_build /opt/sherpa/${SHERPA_VERSION} /opt/sherpa/${SHERPA_VERSION}
COPY --from=sherpa_build /opt/hepmc3/git-master /opt/hepmc3/git-master

ENV CMAKE_PREFIX_PATH=/opt/hepmc3/git-master
ENV SHERPA_VERSION=2.3.0


