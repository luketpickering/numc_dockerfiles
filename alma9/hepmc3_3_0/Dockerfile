# syntax=docker/dockerfile:1
FROM picker24/buildbox:alma9 AS build
WORKDIR /

RUN mkdir -p /opt/HepMC3-build
WORKDIR /opt

RUN git clone --depth=1 --branch 3.3.0 https://gitlab.cern.ch/hepmc/HepMC3.git HepMC3-src

WORKDIR /opt/HepMC3-build
RUN cmake /opt/HepMC3-src \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_INSTALL_PREFIX=/opt/HepMC3/3.3.0 \
  -DHEPMC3_ENABLE_PROTOBUFIO=ON \
  -DHEPMC3_ENABLE_ROOTIO=OFF \
  -DHEPMC3_Python_SITEARCH39=/opt/HepMC3/3.3.0/lib64/python3.9/site-packages \
  && make install -j 4

WORKDIR /opt/HepMC3-src
RUN git rev-parse --short HEAD > /opt/HepMC3/3.3.0/git.shorthash

FROM picker24/buildbox:alma9
WORKDIR /

COPY --from=build /opt/HepMC3/ /opt/HepMC3/
COPY --from=build /opt/HepMC3-src/ /opt/HepMC3-src/

ENV PATH=/opt/HepMC3/3.3.0/bin:${PATH} \
    LD_LIBRARY_PATH=/opt/HepMC3/3.3.0/lib64:${LD_LIBRARY_PATH} \
    CMAKE_PREFIX_PATH=/opt/HepMC3/3.3.0:${CMAKE_PREFIX_PATH} \
    PYTHONPATH=/opt/HepMC3/3.3.0/lib64/python3.9/site-packages:${PYTHONPATH} \
