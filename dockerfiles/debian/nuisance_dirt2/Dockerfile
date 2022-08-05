# syntax=docker/dockerfile:1
FROM picker24/nusystematics:debian_bullseye-slim AS nuisance_build

WORKDIR /opt

# pull in NuWro
COPY --from=picker24/nuwro_21_09:debian_bullseye-slim /opt/nuwro/21_09/ /opt/nuwro/21_09/

ENV NUWRO=/opt/nuwro/21_09
ENV PATH=${NUWRO}/bin:${PATH}
ENV ROOT_INCLUDE_PATH=${NUWRO}/src:${ROOT_INCLUDE_PATH}

# pull in GiBUU
COPY --from=picker24/gibuu_2021:debian_bullseye-slim /opt/GiBUU/ /opt/GiBUU/

ENV GiBUU=/opt/GiBUU/2021
ENV GiBUU_JOBCARDS=/opt/GiBUU/2021/jobCards
ENV GiBUU_BUUINPUTS=/opt/GiBUU/2021/buuinput
ENV PATH=${GiBUU}/bin:${PATH}

# Pull in NEUT
COPY --from=picker24/neut_550:debian_bullseye-slim /opt/cernlib /opt/cernlib
ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT /opt/cernlib/2005

ENV NEUT_VERSION=5.5.0
COPY --from=picker24/neut_550:debian_bullseye-slim /opt/neut /opt/neut
ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}
ENV PATH=${NEUT_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH}
ENV NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat
ENV NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards
ENV ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH}

ENV PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}

ENV INV_CACHE=2

RUN git clone https://github.com/NUISANCEMC/nuisance.git nuisance-src
WORKDIR /opt/nuisance-src
RUN git checkout feature/validation_scripts
RUN mkdir /opt/nuisance-build

WORKDIR /opt/nuisance-build
RUN cmake /opt/nuisance-src -DCMAKE_INSTALL_PREFIX=/opt/nuisance
RUN make -j 5
RUN make install

FROM picker24/nusystematics:debian_bullseye-slim
WORKDIR /

# pull in NuWro
COPY --from=picker24/nuwro_21_09:debian_bullseye-slim /opt/nuwro/21_09/ /opt/nuwro/21_09/

ENV NUWRO=/opt/nuwro/21_09
ENV PATH=${NUWRO}/bin:${PATH}
ENV ROOT_INCLUDE_PATH=${NUWRO}/src:${ROOT_INCLUDE_PATH}

# pull in GiBUU
COPY --from=picker24/gibuu_2021:debian_bullseye-slim /opt/GiBUU/ /opt/GiBUU/

ENV GiBUU=/opt/GiBUU/2021
ENV GiBUU_JOBCARDS=/opt/GiBUU/2021/jobCards
ENV GiBUU_BUUINPUTS=/opt/GiBUU/2021/buuinput
ENV PATH=${GiBUU}/bin:${PATH}

# Pull in NEUT
COPY --from=picker24/neut_550:debian_bullseye-slim /opt/cernlib /opt/cernlib
ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT /opt/cernlib/2005

ENV NEUT_VERSION=5.5.0
COPY --from=picker24/neut_550:debian_bullseye-slim /opt/neut /opt/neut
ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}
ENV PATH=${NEUT_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH}
ENV NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat
ENV NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards
ENV ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH}

ENV PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}

COPY --from=nuisance_build /opt/nuisance/ /opt/nuisance/

ENV NUISANCE=/opt/nuisance
ENV PATH=${NUISANCE}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NUISANCE}/lib:${LD_LIBRARY_PATH}
