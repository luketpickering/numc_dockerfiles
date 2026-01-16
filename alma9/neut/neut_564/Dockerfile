# syntax=docker/dockerfile:1
FROM picker24/root_v6_28_08:alma9 AS neut_build
WORKDIR /

WORKDIR /opt/neut
RUN --mount=type=ssh git clone --branch t2k/5.6.4.3 --depth 1 git@github.com:neut-devel/neut.git ${NEUT_VERSION}
WORKDIR /opt/neut/${NEUT_VERSION}/src
RUN find . -name trapfpe.c -exec sed -i "s/(_FPU_DEFAULT & ~_FPU_EXTENDED) | _FPU_DOUBLE/_FPU_DEFAULT/g" \{} \;
RUN autoreconf -if

RUN mkdir -p /opt/neut-build/${NEUT_VERSION}
WORKDIR /opt/neut-build/${NEUT_VERSION}
RUN /opt/neut/${NEUT_VERSION}/src/configure --prefix=/opt/neut/${NEUT_VERSION} --enable-builtin-cernlib --enable-debug
RUN CERNLIB_NJOBS="-j 4" make install
RUN sed -i "s:PATHS \${NEUT_PREFIX}:PATHS \${NEUT_PREFIX}/bin:g" /opt/neut/5.6.4.3/cmake/NEUTConfig.cmake

ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION} \
    PKG_CONFIG_PATH=/opt/neut/${NEUT_VERSION}

RUN git clone https://github.com/neut-devel/neutvect-converter.git

RUN mkdir /opt/neut-build/${NEUT_VERSION}/neutvect-converter/build
WORKDIR /opt/neut-build/${NEUT_VERSION}/neutvect-converter/build
RUN cmake ../ -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/opt/neut/${NEUT_VERSION}
RUN make install -j 4

WORKDIR /opt/neut/${NEUT_VERSION}
RUN git rev-parse --short HEAD > /opt/neut/${NEUT_VERSION}/git.shorthash

#final image
FROM picker24/root_v6_28_08:alma9
WORKDIR /

COPY --from=neut_build /opt/cernlib /opt/cernlib
ENV CERN=/opt/cernlib \
    CERN_LEVEL=2005 \
    CERN_ROOT=/opt/cernlib/2005

ENV NEUT_VERSION=5.6.4
ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}
ENV PATH=${NEUT_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH} \
    NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat \
    NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards \
    ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH} \
    PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}

RUN mkdir -p /opt/neut/src
COPY --from=neut_build /opt/neut/${NEUT_VERSION} /opt/neut/${NEUT_VERSION}
RUN ln -s ${NEUT_ROOT}/include /opt/neut/src/neutclass