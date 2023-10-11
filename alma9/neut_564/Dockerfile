# syntax=docker/dockerfile:1
FROM picker24/root_v6_26_10:alma9 AS neut_build
WORKDIR /

COPY --from=picker24/cernlib:alma9 /opt/cernlib /opt/cernlib
ENV CERN=/opt/cernlib \
    CERN_LEVEL=2005 \
    CERN_ROOT=/opt/cernlib/2005

ENV NEUT_VERSION=5.6.4

RUN mkdir -p /opt/neut-build
RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:neut-devel/neut.git neut
WORKDIR /opt/neut
RUN git checkout 5.6.4
WORKDIR /opt/neut/src
RUN find . -name trapfpe.c -exec sed -i "s/(_FPU_DEFAULT & ~_FPU_EXTENDED) | _FPU_DOUBLE/_FPU_DEFAULT/g" \{} \;
RUN autoreconf -if

WORKDIR /opt/neut-build
RUN /opt/neut/src/configure --prefix=/opt/neut/${NEUT_VERSION}
RUN make install -j 4

WORKDIR /opt/neut
RUN git rev-parse --short HEAD > /opt/neut/${NEUT_VERSION}/git.shorthash

#final image
FROM picker24/root_v6_26_10:alma9
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