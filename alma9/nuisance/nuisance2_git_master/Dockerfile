FROM picker24/genbox:alma9 AS build
WORKDIR /

WORKDIR /opt/
RUN git clone https://github.com/NUISANCEMC/nuisance.git nuisance-src
RUN mkdir nuisance-build
WORKDIR /opt/nuisance-build
RUN cmake /opt/nuisance-src \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_INSTALL_PREFIX=/opt/nuisance/git_master \
      -DNuHepMC_ENABLED=ON \
    && make install -j 8

WORKDIR /opt/nuisance-src
RUN git rev-parse --short HEAD > /opt/nuisance/git_master/git.shorthash

FROM picker24/genbox:alma9
WORKDIR /

COPY --from=build /opt/nuisance/git_master /opt/nuisance/git_master

ENV NUISANCE=/opt/nuisance/git_master
ENV PATH=${NUISANCE}/bin:${PATH} \
    LD_LIBRARY_PATH=${NUISANCE}/lib:${NUISANCE}/lib64:${LD_LIBRARY_PATH}