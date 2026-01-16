# syntax=docker/dockerfile:1
FROM picker24/highland_2_83:alma9 AS t2krw_build
WORKDIR /

COPY --from=picker24/neut_562:alma9 /opt/cernlib /opt/cernlib
ENV CERN=/opt/cernlib \
    CERN_LEVEL=2005 \
    CERN_ROOT=/opt/cernlib/2005

RUN mkdir /opt/neut
ENV NEUT_VERSION=5.6.2
COPY --from=picker24/neut_562:alma9 /opt/neut/${NEUT_VERSION} /opt/neut/${NEUT_VERSION}
ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}
ENV PATH=${NEUT_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH} \
    NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat \
    NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards \
    ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH} \
    PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}


RUN mkdir -p /opt/neut/src/
RUN ln -s ${NEUT_ROOT}/include /opt/neut/src/neutclass
ENV ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH}

ENV PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

# build Prob3plusplus
WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:mach3-software/Prob3plusplus.git prob3plusplus-src
RUN mkdir -p /opt/prob3plusplus-build
WORKDIR /opt/prob3plusplus-build
RUN cmake /opt/prob3plusplus-src -DCMAKE_INSTALL_PREFIX=/opt/prob3plusplus/git-master
RUN make install
WORKDIR /opt/prob3plusplus-src
RUN git rev-parse --short HEAD > /opt/prob3plusplus/git-master/git.shorthash
ENV Prob3plusplus_ROOT=/opt/prob3plusplus/git-master

COPY --from=picker24/geantreweight_23_03:alma9 /opt/fsifitter /opt/fsifitter
COPY --from=picker24/geantreweight_23_03:alma9 /opt/geantreweight /opt/geantreweight
ENV FSIFITTER_VERSION=22.05 \
    OCT_VERSION=5.2.0 \
    GEANTReWeight_VERSION=23.03

ENV OCT_PREFIX=/opt/fsifitter/${FSIFITTER_VERSION}/octave/${OCT_VERSION}/Linux \
    FSIFITTERROOT=/opt/fsifitter/${FSIFITTER_VERSION} \
    GEANTREWEIGHT=/opt/geantreweight/${GEANTReWeight_VERSION}

ENV GEANTReWeight_ROOT=${GEANTREWEIGHT} \
    PATH=${OCT_PREFIX}/bin:${PATH} \
    LD_LIBRARY_PATH=${GEANTREWEIGHT}:${FSIFITTERROOT}:${OCT_PREFIX}/lib/octave/${OCT_VERSION}:${LD_LIBRARY_PATH}

# build NIWG
ENV NIWG_VERSION=23.03

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:t2k-software/NIWGReWeight.git niwgreweight
WORKDIR /opt/niwgreweight
RUN git checkout ${NIWG_VERSION}

RUN mkdir -p /opt/niwgreweight-build
WORKDIR /opt/niwgreweight-build
RUN cmake /opt/niwgreweight \
  -DCMAKE_INSTALL_PREFIX=/opt/niwgreweight/${NIWG_VERSION}
RUN make && make install
RUN mv /opt/niwgreweight /opt/niwgreweight-src && \
    mkdir -p /opt/niwgreweight  && \
    mv /opt/niwgreweight-src/${NIWG_VERSION} /opt/niwgreweight/${NIWG_VERSION}

ENV NIWG_ROOT="/opt/niwgreweight/${NIWG_VERSION}"
ENV PATH=${NIWG_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NIWG_ROOT}/lib:${LD_LIBRARY_PATH}

WORKDIR /opt/niwgreweight-src
RUN git rev-parse --short HEAD > ${NIWG_ROOT}/git.shorthash

ENV T2KREWEIGHT_VERSION=23.03

RUN mkdir -p /opt/t2kreweight/${T2KREWEIGHT_VERSION}

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:t2k-software/T2KReWeight.git t2kreweight-src
WORKDIR /opt/t2kreweight-src
RUN git checkout ${T2KREWEIGHT_VERSION}

RUN mkdir -p /opt/t2kreweight-build
WORKDIR /opt/t2kreweight-build
RUN cmake /opt/t2kreweight-src \
  -DCMAKE_INSTALL_PREFIX=/opt/t2kreweight/${T2KREWEIGHT_VERSION} \
  -DNIWG_ENABLED=ON \
  -DNEUT_ENABLED=ON \
  -DGEANTReWeight_ENABLED=ON \
  -DOAAnalysisReader_ENABLED=ON \
  -DProb3plusplus_ENABLED=ON
RUN make VERBOSE=1 && make install

ENV T2KReWeight_ROOT="/opt/t2kreweight/${T2KREWEIGHT_VERSION}"
ENV PATH=${T2KReWeight_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${T2KReWeight_ROOT}/lib:${LD_LIBRARY_PATH}

WORKDIR /opt/t2kreweight-src
RUN git rev-parse --short HEAD > ${T2KReWeight_ROOT}/git.shorthash

FROM picker24/highland_2_83:alma9
WORKDIR /

COPY --from=picker24/neut_562:alma9 /opt/cernlib /opt/cernlib
ENV CERN=/opt/cernlib \
    CERN_LEVEL=2005 \
    CERN_ROOT=/opt/cernlib/2005

RUN mkdir -p /opt/neut/src
ENV NEUT_VERSION=5.6.2
ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}
ENV PATH=${NEUT_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH} \
    NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat \
    NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards \
    ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH} \
    PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}

COPY --from=picker24/neut_562:alma9 /opt/neut/${NEUT_VERSION} /opt/neut/${NEUT_VERSION}
RUN ln -s ${NEUT_ROOT}/include /opt/neut/src/neutclass

COPY --from=t2krw_build /opt/prob3plusplus /opt/prob3plusplus
ENV Prob3plusplus_ROOT=/opt/prob3plusplus/git-master
ENV LD_LIBRARY_PATH=${Prob3plusplus_ROOT}/lib:${LD_LIBRARY_PATH}

COPY --from=t2krw_build /opt/fsifitter /opt/fsifitter
COPY --from=t2krw_build /opt/geantreweight /opt/geantreweight
ENV FSIFITTER_VERSION=22.05 \
    OCT_VERSION=5.2.0 \
    GEANTReWeight_VERSION=23.03

ENV OCT_PREFIX=/opt/fsifitter/${FSIFITTER_VERSION}/octave/${OCT_VERSION}/Linux \
    FSIFITTERROOT=/opt/fsifitter/${FSIFITTER_VERSION} \
    GEANTREWEIGHT=/opt/geantreweight/${GEANTReWeight_VERSION}

ENV GEANTReWeight_ROOT=${GEANTREWEIGHT} \
    PATH=${OCT_PREFIX}/bin:${PATH} \
    LD_LIBRARY_PATH=${GEANTREWEIGHT}:${FSIFITTERROOT}:${OCT_PREFIX}/lib/octave/${OCT_VERSION}:${LD_LIBRARY_PATH}

COPY --from=t2krw_build /opt/niwgreweight /opt/niwgreweight
COPY --from=t2krw_build /opt/t2kreweight /opt/t2kreweight

ENV NIWG_VERSION=23.03 \
    T2KREWEIGHT_VERSION=23.03
ENV NIWG_ROOT=/opt/niwgreweight/${NIWG_VERSION} \
    T2KReWeight_ROOT=/opt/t2kreweight/${T2KREWEIGHT_VERSION} 
ENV PATH=${T2KReWeight_ROOT}/bin:${NIWG_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${T2KReWeight_ROOT}/lib:${NIWG_ROOT}/lib:${LD_LIBRARY_PATH}
RUN ln -s ${NIWG_ROOT}/include /opt/niwgreweight/src
