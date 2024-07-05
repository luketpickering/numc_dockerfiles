# syntax=docker/dockerfile:1
FROM picker24/highland_2_81:centos7-x86_64 AS niwg_build
WORKDIR /

# Pull in NEUT
COPY --from=picker24/foreric_neut550:centos7-x86_64 /opt/cernlib /opt/cernlib
ENV CERN /opt/cernlib \
    CERN_LEVEL 2005 \
    CERN_ROOT /opt/cernlib/2005

ENV NEUT_VERSION=5.5.0
ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}
COPY --from=picker24/foreric_neut550:centos7-x86_64 /opt/neut /opt/neut
ENV PATH=${NEUT_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH} \
    NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat \
    NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards \
    ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH} \
    PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

# build FSIFitter
ENV FSIFITTER_VERSION=22.05

RUN mkdir -p /opt/fsifitter
WORKDIR /opt/fsifitter
RUN --mount=type=ssh git clone git@github.com:t2k-software/FSIFitter.git ${FSIFITTER_VERSION}
WORKDIR /opt/fsifitter/${FSIFITTER_VERSION}
RUN git checkout 22.05
RUN ./build_octave.sh
ENV OCT_VERSION=5.2.0
ENV OCT_PREFIX=/opt/fsifitter/${FSIFITTER_VERSION}/octave/${OCT_VERSION}/Linux
ENV PATH=${OCT_PREFIX}/bin:${PATH}
ENV LD_LIBRARY_PATH=${OCT_PREFIX}/lib/octave/${OCT_VERSION}/:${LD_LIBRARY_PATH}
RUN CXXFLAGS=-std=c++11 make

WORKDIR /opt
RUN mv /opt/fsifitter /opt/fsifitter-build
RUN mkdir -p /opt/fsifitter/${FSIFITTER_VERSION}
RUN mv /opt/fsifitter-build/${FSIFITTER_VERSION}/{*.hxx,*.so} /opt/fsifitter/${FSIFITTER_VERSION}/

RUN mkdir -p /opt/fsifitter/${FSIFITTER_VERSION}/octave/${OCT_VERSION}
RUN mv /opt/fsifitter-build/${FSIFITTER_VERSION}/octave/${OCT_VERSION}/Linux /opt/fsifitter/${FSIFITTER_VERSION}/octave/${OCT_VERSION}/

ENV FSIFITTERROOT=/opt/fsifitter/${FSIFITTER_VERSION}
ENV LD_LIBRARY_PATH=${FSIFITTERROOT}:${LD_LIBRARY_PATH}

# build GEANTReWeight
ENV GEANTReWeight_VERSION=22.05

RUN mkdir -p /opt/geantreweight
WORKDIR /opt/geantreweight
RUN --mount=type=ssh git clone git@github.com:t2k-software/GEANTReWeight.git ${GEANTReWeight_VERSION}
WORKDIR /opt/geantreweight/${GEANTReWeight_VERSION}
RUN git checkout 22.05
RUN make

WORKDIR /opt
RUN mv /opt/geantreweight /opt/geantreweight-build
RUN mkdir -p /opt/geantreweight/${GEANTReWeight_VERSION}
RUN mv /opt/geantreweight-build/${GEANTReWeight_VERSION}/{*.h,*.so,*.cmake} /opt/geantreweight/${GEANTReWeight_VERSION}/
RUN mv /opt/geantreweight-build/${GEANTReWeight_VERSION}/inputs /opt/geantreweight/${GEANTReWeight_VERSION}/

ENV GEANTREWEIGHT=/opt/geantreweight/${GEANTReWeight_VERSION}
ENV GEANTReWeight_ROOT=${GEANTREWEIGHT}
ENV LD_LIBRARY_PATH=${GEANTReWeight_ROOT}:${LD_LIBRARY_PATH}

# build NIWG
ENV NIWG_VERSION=22.05

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:t2k-software/NIWGReWeight.git niwgreweight
WORKDIR /opt/niwgreweight
RUN git checkout 22.05

RUN mkdir -p /opt/niwgreweight-build
WORKDIR /opt/niwgreweight-build
RUN cmake /opt/niwgreweight \
  -DCMAKE_INSTALL_PREFIX=/opt/niwgreweight/${NIWG_VERSION} \
  -DCMAKE_CXX_STANDARD=11
RUN make VERBOSE=1 && make install

ENV NIWG_ROOT="/opt/niwgreweight/${NIWG_VERSION}"
ENV PATH=${NIWG_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NIWG_ROOT}/lib:${LD_LIBRARY_PATH}

# new build layer
FROM niwg_build AS t2krw_build
WORKDIR /

ENV T2KREWEIGHT_VERSION=22.05

RUN mkdir -p /opt/t2kreweight/${T2KREWEIGHT_VERSION}

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:t2k-software/T2KReWeight.git t2kreweight-src
WORKDIR /opt/t2kreweight-src
RUN git checkout 22.05

RUN mkdir -p /opt/t2kreweight-build
WORKDIR /opt/t2kreweight-build
RUN cmake /opt/t2kreweight-src \
  -DCMAKE_INSTALL_PREFIX=/opt/t2kreweight/${T2KREWEIGHT_VERSION} \
  -DCMAKE_CXX_STANDARD=11
RUN make && make install

# new layer
FROM picker24/highland_2_81:centos7-x86_64
WORKDIR /

# Pull in NEUT
COPY --from=picker24/foreric_neut550:centos7-x86_64 /opt/cernlib /opt/cernlib
ENV CERN /opt/cernlib \
    CERN_LEVEL 2005 \
    CERN_ROOT /opt/cernlib/2005

ENV NEUT_VERSION=5.5.0 \
    NEUT_ROOT=/opt/neut/5.5.0
COPY --from=picker24/foreric_neut550:centos7-x86_64 /opt/neut /opt/neut
ENV PATH=${NEUT_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH} \
    NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat \
    NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards \
    ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH} \
    PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}

ENV FSIFITTER_VERSION=22.05 \
    OCT_VERSION=5.2.0 \
    FSIFITTERROOT=/opt/fsifitter/22.05 \
    OCT_PREFIX=/opt/fsifitter/22.05/octave/5.2.0/Linux
ENV PATH=${OCT_PREFIX}/bin:${PATH} \
    LD_LIBRARY_PATH=${OCT_PREFIX}/lib/octave/${OCT_VERSION}:${FSIFITTERROOT}:${LD_LIBRARY_PATH}
COPY --from=niwg_build ${FSIFITTERROOT} ${FSIFITTERROOT}

ENV GEANTReWeight_VERSION=22.05 \
    GEANTREWEIGHT=/opt/geantreweight/22.05 \
    GEANTReWeight_ROOT=/opt/geantreweight/22.05
ENV LD_LIBRARY_PATH=${GEANTReWeight_ROOT}:${LD_LIBRARY_PATH}
COPY --from=niwg_build ${GEANTReWeight_ROOT} ${GEANTReWeight_ROOT}

RUN mkdir /opt/niwgreweight
ENV NIWG_VERSION=22.05 \
    NIWG_ROOT=/opt/niwgreweight/22.05 \
    PATH=/opt/niwgreweight/22.05/bin:${PATH} \
    LD_LIBRARY_PATH=${NIWG_ROOT}/lib:${LD_LIBRARY_PATH}
COPY --from=t2krw_build ${NIWG_ROOT} ${NIWG_ROOT}
RUN ln -s ${NIWG_ROOT}/include /opt/niwgreweight/src

COPY --from=t2krw_build /opt/t2kreweight /opt/t2kreweight
ENV T2KREWEIGHT_VERSION=22.05 \
    T2KReWeight_ROOT=/opt/t2kreweight/22.05 \
    PATH=/opt/t2kreweight/22.05/bin:${PATH} \
    LD_LIBRARY_PATH=/opt/t2kreweight/22.05/lib:${LD_LIBRARY_PATH}