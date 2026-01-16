# syntax=docker/dockerfile:1
FROM picker24/root_v6_30_08:alma9 AS neut_build
WORKDIR /

ENV NEUT_VERSION=git_master

RUN mkdir -p /opt/neut-build
RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

WORKDIR /opt
RUN --mount=type=ssh git clone --depth 1 git@github.com:neut-devel/neut.git neut-src

WORKDIR /opt/neut-build
RUN cmake /opt/neut-src -DCMAKE_INSTALL_PREFIX=/opt/neut/${NEUT_VERSION}
RUN make install -j 4

WORKDIR /opt/neut-src
RUN git rev-parse --short HEAD > /opt/neut/${NEUT_VERSION}/git.shorthash

#final image
FROM picker24/root_v6_30_08:alma9
WORKDIR /

ENV NEUT_VERSION=git_master \
    NEUT_ROOT=/opt/neut/git_master
ENV PATH=${NEUT_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH} \
    NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat \
    NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards \
    ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH} \
    PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}

COPY --from=neut_build /opt/neut /opt/neut