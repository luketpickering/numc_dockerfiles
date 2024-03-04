# syntax=docker/dockerfile:1
FROM picker24/genie_3_04_00:alma9 AS nusystematics_build
WORKDIR /

WORKDIR /opt
RUN git clone --depth  1 https://github.com/luketpickering/fhicl-cpp-standalone.git fhicl-cpp-standalone-src
RUN mkdir -p /opt/fhicl-cpp-standalone-build
WORKDIR /opt/fhicl-cpp-standalone-build
RUN cmake /opt/fhicl-cpp-standalone-src -DCMAKE_INSTALL_PREFIX=/opt/fhicl-cpp-standalone
RUN make install -j 4
ENV CMAKE_PREFIX_PATH=/opt/fhicl-cpp-standalone:${CMAKE_PREFIX_PATH}

WORKDIR /opt
RUN git clone --depth  1 --branch v02_00_01 https://github.com/NuSystematics/nusystematics.git nusystematics-src
RUN mkdir -p /opt/nusystematics-build
WORKDIR /opt/nusystematics-build
RUN cmake /opt/nusystematics-src -DCMAKE_INSTALL_PREFIX=/opt/nusystematics/v02_00_01
RUN make install -j 4
WORKDIR /opt/nusystematics-src
RUN git rev-parse --short HEAD > /opt/nusystematics/git.shorthash

FROM picker24/genie_3_04_00:alma9
WORKDIR /

COPY --from=nusystematics_build /opt/nusystematics /opt/nusystematics
COPY --from=nusystematics_build /opt/fhicl-cpp-standalone /opt/fhicl-cpp-standalone
ENV nusystematics_ROOT=/opt/nusystematics/v02_00_01 \
    nusystematics_VERSION=02_00_01 \
    CMAKE_PREFIX_PATH=/opt/fhicl-cpp-standalone:${CMAKE_PREFIX_PATH} \
    PATH=/opt/nusystematics/v02_00_01/bin:/opt/fhicl-cpp-standalone/bin:${PATH} \
    LD_LIBRARY_PATH=/opt/nusystematics/v02_00_01/lib:/opt/fhicl-cpp-standalone/lib:/opt/fhicl-cpp-standalone/libexec:${LD_LIBRARY_PATH}
