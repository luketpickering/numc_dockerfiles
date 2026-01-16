# syntax=docker/dockerfile:1
FROM picker24/t2kfitterenv_23_03:alma9 AS oagwa_build
WORKDIR /

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:t2k-software/OAGenWeightsApps.git oagenweightsapps-src
WORKDIR /opt/oagenweightsapps-src
RUN git checkout feature/NDTunerApp

RUN mkdir -p /opt/oagenweightsapps-build
WORKDIR /opt/oagenweightsapps-build
RUN cmake /opt/oagenweightsapps-src \
  -DCMAKE_INSTALL_PREFIX=/opt/oagenweightsapps \
  -DCMAKE_CXX_STANDARD=17
RUN make && make install

FROM picker24/t2kfitterenv_23_03:alma9
WORKDIR /

COPY --from=oagwa_build /opt/oagenweightsapps /opt/oagenweightsapps
ENV OAGENWEIGHTSROOT=/opt/oagenweightsapps
ENV PATH=${OAGENWEIGHTSROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${OAGENWEIGHTSROOT}/lib:${LD_LIBRARY_PATH}
