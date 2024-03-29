# syntax=docker/dockerfile:1

FROM picker24/geant_10_7_3:debian_bullseye-slim as edepsim_build
WORKDIR /

ENV EDEPSIM_VERSION=3.2.0

RUN mkdir -p /opt/edep-sim/build /opt/edep-sim/${EDEPSIM_VERSION}
WORKDIR /opt/edep-sim/
RUN git clone https://github.com/ClarkMcGrew/edep-sim.git src
WORKDIR /opt/edep-sim/src
RUN git checkout ${EDEPSIM_VERSION}
WORKDIR /opt/edep-sim/build
RUN cmake  -DCMAKE_INSTALL_PREFIX=/opt/edep-sim/${EDEPSIM_VERSION} \
      /opt/edep-sim/src
RUN make -j 8 && make install

FROM picker24/geant_10_7_3:debian_bullseye-slim
WORKDIR /

ENV EDEPSIM_VERSION=3.2.0
COPY --from=edepsim_build /opt/edep-sim/${EDEPSIM_VERSION} /opt/edep-sim/${EDEPSIM_VERSION}

ENV PATH=/opt/edep-sim/${EDEPSIM_VERSION}/bin:${PATH}

ENV LD_LIBRARY_PATH=/opt/edep-sim/${EDEPSIM_VERSION}/lib:${LD_LIBRARY_PATH}
