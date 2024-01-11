# syntax=docker/dockerfile:1
FROM picker24/neut_564:alma9 AS t2krw_build
WORKDIR /

COPY --from=picker24/geantreweight_23_10:alma9 /opt/fsifitter /opt/fsifitter
COPY --from=picker24/geantreweight_23_10:alma9 /opt/geantreweight /opt/geantreweight

ENV FSIFITTER_VERSION=22.05 \
    OCT_VERSION=5.2.0 \
    GEANTReWeight_VERSION=23.10

ENV OCT_PREFIX=/opt/fsifitter/${FSIFITTER_VERSION}/octave/${OCT_VERSION}/Linux \
    FSIFITTERROOT=/opt/fsifitter/${FSIFITTER_VERSION} \
    GEANTREWEIGHT=/opt/geantreweight/${GEANTReWeight_VERSION}

ENV GEANTReWeight_ROOT=${GEANTREWEIGHT} \
    PATH=${OCT_PREFIX}/bin:${PATH} \
    LD_LIBRARY_PATH=${GEANTREWEIGHT}:${FSIFITTERROOT}:${OCT_PREFIX}/lib/octave/${OCT_VERSION}:${LD_LIBRARY_PATH}

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

ENV T2KREWEIGHT_VERSION=23.10

RUN mkdir -p /opt/t2kreweight/${T2KREWEIGHT_VERSION}

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:t2k-software/T2KReWeight.git t2kreweight-src
WORKDIR /opt/t2kreweight-src
RUN git checkout ${T2KREWEIGHT_VERSION}

RUN mkdir -p /opt/t2kreweight-build
WORKDIR /opt/t2kreweight-build
RUN --mount=type=ssh cmake /opt/t2kreweight-src \
  -DCMAKE_INSTALL_PREFIX=/opt/t2kreweight/${T2KREWEIGHT_VERSION} \
  -DNIWG_ENABLED=ON \
  -DBUILTIN_NIWG_ENABLED=ON \
  -DNEUT_ENABLED=ON \
  -DGEANTReWeight_ENABLED=ON \
  -DOAAnalysisReader_ENABLED=OFF \
  -DProb3plusplus_ENABLED=ON
RUN make VERBOSE=1 && make install

WORKDIR /opt/t2kreweight-src
RUN git rev-parse --short HEAD > ${T2KReWeight_ROOT}/git.shorthash

FROM picker24/neut_564:alma9
WORKDIR /

COPY --from=t2krw_build /opt/t2kreweight /opt/t2kreweight
COPY --from=t2krw_build /opt/fsifitter /opt/fsifitter
COPY --from=t2krw_build /opt/geantreweight /opt/geantreweight

ENV FSIFITTER_VERSION=22.05 \
    OCT_VERSION=5.2.0 \
    GEANTReWeight_VERSION=23.10

ENV OCT_PREFIX=/opt/fsifitter/${FSIFITTER_VERSION}/octave/${OCT_VERSION}/Linux \
    FSIFITTERROOT=/opt/fsifitter/${FSIFITTER_VERSION} \
    GEANTREWEIGHT=/opt/geantreweight/${GEANTReWeight_VERSION}

ENV GEANTReWeight_ROOT=${GEANTREWEIGHT} \
    PATH=${OCT_PREFIX}/bin:${PATH} \
    LD_LIBRARY_PATH=${GEANTREWEIGHT}:${FSIFITTERROOT}:${OCT_PREFIX}/lib/octave/${OCT_VERSION}:${LD_LIBRARY_PATH}

ENV NIWG_VERSION=23.10 \
    T2KREWEIGHT_VERSION=23.10
#T2KReWeight is installing NIWG for us
ENV NIWG_ROOT=/opt/t2kreweight/${NIWG_VERSION} \
    T2KReWeight_ROOT=/opt/t2kreweight/${T2KREWEIGHT_VERSION} 
ENV PATH=${T2KReWeight_ROOT}/bin:${NIWG_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${T2KReWeight_ROOT}/lib:${LD_LIBRARY_PATH}
