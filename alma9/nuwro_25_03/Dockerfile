FROM picker24/nuhepmc_git_master:alma9 AS nuwro_build
WORKDIR /

WORKDIR /opt/
RUN git clone --depth  1 --branch NuWro_25_03_1 https://github.com/NuWro/nuwro.git nuwro-src
WORKDIR /opt/nuwro-src
RUN make

FROM picker24/nuhepmc_git_master:alma9 as nuwroconv_build
WORKDIR /

RUN mkdir -p /opt/nuwro/25.03.1/src/dis
RUN mkdir -p /opt/nuwro/25.03.1/src/espp
RUN mkdir -p /opt/nuwro/25.03.1/src/sf
RUN mkdir -p /opt/nuwro/25.03.1/src/rpa
RUN mkdir -p /opt/nuwro/25.03.1/src/rew
COPY --from=nuwro_build /opt/nuwro-src/data /opt/nuwro/25.03.1/data
COPY --from=nuwro_build /opt/nuwro-src/bin /opt/nuwro/25.03.1/bin
COPY --from=nuwro_build /opt/nuwro-src/src/*.h /opt/nuwro/25.03.1/src/
COPY --from=nuwro_build /opt/nuwro-src/src/dis/*.h /opt/nuwro/25.03.1/src/dis/
COPY --from=nuwro_build /opt/nuwro-src/src/espp/*.h /opt/nuwro/25.03.1/src/espp/
COPY --from=nuwro_build /opt/nuwro-src/src/sf/*.h /opt/nuwro/25.03.1/src/sf/
COPY --from=nuwro_build /opt/nuwro-src/src/rpa/*.h /opt/nuwro/25.03.1/src/rpa/
COPY --from=nuwro_build /opt/nuwro-src/src/rew/*.h /opt/nuwro/25.03.1/src/rew/

ENV NUWRO=/opt/nuwro/25.03.1
ENV PATH=${NUWRO}/bin:${PATH} \
    ROOT_INCLUDE_PATH=${NUWRO}/src:${ROOT_INCLUDE_PATH}

RUN mkdir -p /opt
WORKDIR /opt

RUN git clone https://github.com/NuHepMC/nuwro2hepmc3.git

RUN mkdir /opt/nuwro2hepmc3/build
WORKDIR /opt/nuwro2hepmc3/build
RUN cmake ../ -DCMAKE_INSTALL_PREFIX=/opt/nuwro/25.03.1
RUN make install -j 4

FROM picker24/nuhepmc_git_master:alma9
WORKDIR /

COPY --from=nuwroconv_build /opt/nuwro /opt/nuwro

ENV NUWRO=/opt/nuwro/25.03.1
ENV PATH=${NUWRO}/bin:${PATH} \
    nuwroconv_ROOT=${NUWRO} \
    ROOT_INCLUDE_PATH=${NUWRO}/src:${ROOT_INCLUDE_PATH}
