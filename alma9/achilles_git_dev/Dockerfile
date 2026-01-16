FROM picker24/nuhepmc_git_master:alma9 AS build

WORKDIR /opt/
RUN git clone --depth  1 --branch dev https://github.com/AchillesGen/Achilles.git achilles-src
RUN mkdir achilles-build
WORKDIR /opt/achilles-build
RUN cmake /opt/achilles-src \
  -DACHILLES_ENABLE_ROOT=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/opt/achilles/dev_master \
    && make install -j 4

WORKDIR /opt/achilles-src
RUN git rev-parse --short HEAD > /opt/achilles/dev_master/git.shorthash

FROM picker24/buildbox:alma9
WORKDIR /

COPY --from=build /opt/achilles/dev_master /opt/achilles/dev_master

ENV ACHILLES=/opt/achilles/dev_master