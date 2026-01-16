# syntax=docker/dockerfile:1
FROM picker24/highland_2_83:alma9 AS t2krw_build
WORKDIR /

RUN mkdir /opt/neut
ENV NEUT_VERSION=5.6.4
COPY --from=picker24/neut_564:alma9 /opt/neut/${NEUT_VERSION} /opt/neut/${NEUT_VERSION}
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

ENV T2KREWEIGHT_VERSION=24.12

RUN mkdir -p /opt/t2kreweight/${T2KREWEIGHT_VERSION}

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:t2k-software/T2KReWeight.git t2kreweight-src
WORKDIR /opt/t2kreweight-src
RUN git checkout ${T2KREWEIGHT_VERSION}

RUN mkdir -p /opt/t2kreweight-build
WORKDIR /opt/t2kreweight-build
RUN --mount=type=ssh cmake /opt/t2kreweight-src \
  -DCMAKE_INSTALL_PREFIX=/opt/t2kreweight/${T2KREWEIGHT_VERSION} \
  -DBUILTIN_NIWG_ENABLED=ON \
  -DNEUT_ENABLED=ON \
  -DGEANTReWeight_ENABLED=OFF \
  -DOAAnalysisReader_ENABLED=ON \
  -DProb3plusplus_ENABLED=OFF
RUN make VERBOSE=1 && make install

ENV T2KReWeight_ROOT="/opt/t2kreweight/${T2KREWEIGHT_VERSION}"
ENV PATH=${T2KReWeight_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${T2KReWeight_ROOT}/lib:${LD_LIBRARY_PATH}

WORKDIR /opt/t2kreweight-src
RUN git rev-parse --short HEAD > ${T2KReWeight_ROOT}/git.shorthash

FROM picker24/highland_2_83:alma9
WORKDIR /

RUN mkdir -p /opt/neut/src
ENV NEUT_VERSION=5.6.4
ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}
ENV PATH=${NEUT_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH} \
    NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat \
    NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards \
    ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH} \
    PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}

COPY --from=picker24/neut_564:alma9 /opt/neut/${NEUT_VERSION} /opt/neut/${NEUT_VERSION}
RUN ln -s ${NEUT_ROOT}/include /opt/neut/src/neutclass

COPY --from=t2krw_build /opt/t2kreweight /opt/t2kreweight

ENV NIWG_VERSION=24.12 \
    T2KREWEIGHT_VERSION=24.12
ENV NIWG_ROOT=/opt/niwgreweight/${NIWG_VERSION} \
    T2KReWeight_ROOT=/opt/t2kreweight/${T2KREWEIGHT_VERSION}
ENV PATH=${T2KReWeight_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${T2KReWeight_ROOT}/lib:${LD_LIBRARY_PATH}
RUN ln -s ${NIWG_ROOT}/include /opt/niwgreweight/src
