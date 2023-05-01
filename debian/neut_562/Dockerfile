# syntax=docker/dockerfile:1
FROM picker24/root_v6_24_06:debian_bullseye-slim AS neut_build
WORKDIR /

COPY --from=picker24/cernlib:debian_bullseye-slim /opt/cernlib /opt/cernlib
ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT /opt/cernlib/2005

ENV NEUT_VERSION=5.6.2

RUN mkdir -p /opt/neut-build
RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:neut-devel/neut.git neut
WORKDIR /opt/neut
RUN git checkout 5.6.2
WORKDIR /opt/neut/src
RUN find . -name trapfpe.c -exec sed -i "s/(_FPU_DEFAULT & ~_FPU_EXTENDED) | _FPU_DOUBLE/_FPU_DEFAULT/g" \{} \;
RUN autoreconf -if

WORKDIR /opt/neut-build
RUN /opt/neut/src/configure --prefix=/opt/neut/${NEUT_VERSION}
RUN make install -j 4

WORKDIR /opt/neut
RUN git rev-parse --short HEAD > /opt/neut/${NEUT_VERSION}/git.shorthash

FROM picker24/root_v6_24_06:debian_bullseye-slim
WORKDIR /

COPY --from=neut_build /opt/cernlib /opt/cernlib
ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT /opt/cernlib/2005

RUN mkdir /opt/neut
ENV NEUT_VERSION=5.6.2
COPY --from=neut_build /opt/neut/${NEUT_VERSION} /opt/neut/${NEUT_VERSION}
ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}
ENV PATH=${NEUT_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH}
ENV NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat
ENV NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards

RUN mkdir -p /opt/neut/src/
RUN ln -s ${NEUT_ROOT}/include /opt/neut/src/neutclass
ENV ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH}

ENV PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}
