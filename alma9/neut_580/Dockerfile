# syntax=docker/dockerfile:1
FROM picker24/root_v6_30_04:alma9 AS neut_build
WORKDIR /

ENV NEUT_VERSION=5.8.0

RUN mkdir -p /opt/neut-build
RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

WORKDIR /opt
RUN --mount=type=ssh git clone --branch ${NEUT_VERSION} --depth 1 git@github.com:neut-devel/neut.git neut
WORKDIR /opt/neut/src
RUN find . -name trapfpe.c -exec sed -i "s/(_FPU_DEFAULT & ~_FPU_EXTENDED) | _FPU_DOUBLE/_FPU_DEFAULT/g" \{} \;
RUN autoreconf -if

WORKDIR /opt/neut-build
RUN /opt/neut/src/configure --prefix=/opt/neut/${NEUT_VERSION} --enable-builtin-cernlib --enable-debug
RUN CERNLIB_NJOBS="-j 4" make install

WORKDIR /opt/neut
RUN git rev-parse --short HEAD > /opt/neut/${NEUT_VERSION}/git.shorthash

#final image
FROM picker24/root_v6_30_04:alma9
WORKDIR /

ENV NEUT_VERSION=5.8.0 \
    NEUT_ROOT=/opt/neut/5.8.0
ENV PATH=${NEUT_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH} \
    NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat \
    NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards \
    ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH} \
    PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}

RUN mkdir -p /opt/neut/src
COPY --from=neut_build /opt/neut/${NEUT_VERSION} /opt/neut/${NEUT_VERSION}
RUN ln -s ${NEUT_ROOT}/include /opt/neut/src/neutclass