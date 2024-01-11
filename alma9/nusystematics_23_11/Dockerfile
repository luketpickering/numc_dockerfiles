# syntax=docker/dockerfile:1

FROM picker24/genie_3_04_00:alma9 AS nusystematics_build
WORKDIR /

#NUSYST_BUILD_ARCH=aarch64
#NUSYST_BUILD_ARCH=x86_64
ARG NUSYST_BUILD_ARCH=x86_64

RUN dnf install -y sqlite-devel

ENV CMAKEVERSION=3.21.7

RUN mkdir -p /opt/CMake-build/${CMAKEVERSION} /opt/CMake/${CMAKEVERSION}/ && cd /opt/CMake-build/${CMAKEVERSION} \
  && wget https://github.com/Kitware/CMake/releases/download/v${CMAKEVERSION}/cmake-${CMAKEVERSION}-linux-${NUSYST_BUILD_ARCH}.tar.gz \
  && tar -zxf cmake-${CMAKEVERSION}-linux-${NUSYST_BUILD_ARCH}.tar.gz \
  && mv /opt/CMake-build/${CMAKEVERSION}/cmake-${CMAKEVERSION}-linux-${NUSYST_BUILD_ARCH}/* /opt/CMake/${CMAKEVERSION}/

ENV PATH=/opt/CMake/${CMAKEVERSION}/bin:${PATH}

WORKDIR /opt
RUN git clone https://github.com/luketpickering/nusystematics.git nusystematics-src
RUN mkdir -p /opt/nusystematics-build
WORKDIR /opt/nusystematics-build
RUN cmake /opt/nusystematics-src -DCMAKE_INSTALL_PREFIX=/opt/nusystematics
RUN make install -j 8
WORKDIR /opt/nusystematics-src
RUN git rev-parse --short HEAD > /opt/nusystematics/git.shorthash

ENV nusystematics_ROOT=/opt/nusystematics

FROM picker24/genie_3_04_00:alma9
WORKDIR /

RUN dnf install -y sqlite-devel

COPY --from=nusystematics_build /opt/CMake /opt/CMake
COPY --from=nusystematics_build /opt/nusystematics /opt/nusystematics
ENV nusystematics_ROOT=/opt/nusystematics \
    nusystematics_VERSION=23.11 \
    PATH=/opt/nusystematics/bin:/opt/CMake/3.21.7/bin:${PATH} \
    LD_LIBRARY_PATH=/opt/nusystematics/lib:/opt/nusystematics/lib64:/opt/nusystematics/libexec:${LD_LIBRARY_PATH}
