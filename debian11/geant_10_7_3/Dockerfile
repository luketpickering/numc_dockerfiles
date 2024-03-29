# syntax=docker/dockerfile:1

FROM picker24/root_v6_24_06:debian_bullseye-slim as geant4_build
WORKDIR /

RUN apt install -y libxerces-c-dev

ENV GEANT4_VERSION=10.7.3

RUN mkdir -p /opt/geant4/build /opt/geant4/${GEANT4_VERSION}
WORKDIR /opt/geant4/
RUN git clone https://gitlab.cern.ch/geant4/geant4.git src
WORKDIR /opt/geant4/src
RUN git checkout v${GEANT4_VERSION}
WORKDIR /opt/geant4/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/opt/geant4/${GEANT4_VERSION} \
      -DGEANT4_INSTALL_DATA=ON \
      -DGEANT4_USE_GDML=ON /opt/geant4/src
RUN make -j 8 && make install

FROM picker24/root_v6_24_06:debian_bullseye-slim
WORKDIR /

RUN apt install -y libxerces-c-dev

ENV GEANT4_VERSION=10.7.3
COPY --from=geant4_build /opt/geant4/${GEANT4_VERSION} /opt/geant4/${GEANT4_VERSION}

ENV PATH=/opt/geant4/${GEANT4_VERSION}/bin:${PATH} \
    LD_LIBRARY_PATH=/opt/geant4/${GEANT4_VERSION}/lib:${LD_LIBRARY_PATH} \
    GEANT4_DATA_DIR=/opt/geant4/${GEANT4_VERSION}/share/Geant4/data \
    G4ENSDFSTATEDATA=/opt/geant4/${GEANT4_VERSION}/share/Geant4-${GEANT4_VERSION}/data/G4ENSDFSTATE2.3 \
    G4PIIDATA=/opt/geant4/${GEANT4_VERSION}/share/Geant4-${GEANT4_VERSION}/data/G4PII1.3 \
    G4INCLDATA=/opt/geant4/${GEANT4_VERSION}/share/Geant4-${GEANT4_VERSION}/data/G4INCL1.0 \
    G4LEDATA=/opt/geant4/${GEANT4_VERSION}/share/Geant4-${GEANT4_VERSION}/data/G4EMLOW7.13 \
    G4PARTICLEXSDATA=/opt/geant4/${GEANT4_VERSION}/share/Geant4-${GEANT4_VERSION}/data/G4PARTICLEXS3.1.1 \
    G4NEUTRONHPDATA=/opt/geant4/${GEANT4_VERSION}/share/Geant4-${GEANT4_VERSION}/data/G4NDL4.6 \
    G4SAIDXSDATA=/opt/geant4/${GEANT4_VERSION}/share/Geant4-${GEANT4_VERSION}/data/G4SAIDDATA2.0 \
    G4REALSURFACEDATA=/opt/geant4/10.7.3/share/Geant4-10.7.3/data/RealSurface2.2 \
    G4ABLADATA=/opt/geant4/10.7.3/share/Geant4-10.7.3/data/G4ABLA3.1 \
    G4LEVELGAMMADATA=/opt/geant4/10.7.3/share/Geant4-10.7.3/data/PhotonEvaporation5.7 \
    G4RADIOACTIVEDATA=/opt/geant4/10.7.3/share/Geant4-10.7.3/data/RadioactiveDecay5.6 \