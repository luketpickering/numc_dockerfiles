# syntax=docker/dockerfile:1
FROM almalinux/9-base AS buildbox_base

RUN dnf -y update \
    && dnf -y install dnf-plugins-core ca-certificates \
    && dnf config-manager --set-enabled crb \
    && dnf -y install epel-release \
    && dnf -y update \
    && dnf -y install  gcc gcc-c++ gcc-gfortran clang-devel llvm-devel make imake autoconf automake pkgconfig libtool valgrind \
                       git wget subversion openssh-clients openssl-devel cvs \
                       xorg-x11-utils \
                       libXt-devel libXpm-devel libXaw-devel libXft-devel libXext-devel libAfterImage-devel graphviz-devel \
                       libuuid-devel xrootd-client-devel xrootd-devel xrootd-server-devel krb5-devel \
                       mesa-libGLU-devel mesa-libGLw glew-devel motif-devel libpng-devel libjpeg-turbo-devel ftgl-devel \
                       libxml2-devel gmp-devel gsl-devel log4cpp-devel bzip2 bzip2-devel pcre-devel xz-devel zlib-devel \
                       freetype-devel fftw-devel blas-devel lapack-devel lz4-devel z3-devel xz-devel libnsl2-devel ncurses-devel \
                       libX11-devel davix-devel libomp-devel libcurl-devel curl-devel glut-devel mesa-dri-drivers cfitsio-devel \
                       gl2ps-devel mysql-devel \
                       eigen3-devel \
                       libzip-devel protobuf-devel protobuf-compiler \
                       libarrow-devel libarrow-python-devel \
                       boost-devel boost-filesystem tbb-devel hdf5-devel sqlite-devel \
                       platform-python-devel python3-numpy python3-pyyaml python3-root \
                       vim nano gdb csh tcsh ed quota patch procmail less which tmux task-spooler procps \
                       libasan libubsan gperftools python3-matplotlib python3-pyarrow \
                       root root-montecarlo-eg root-genvector root-geom root-smatrix root-io-xml

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:/usr/lib:/usr/lib64:/lib:/lib64

#NUMC_BUILD_ARCH=aarch64
#NUMC_BUILD_ARCH=x86_64
ARG NUMC_BUILD_ARCH=x86_64

ARG CMAKEVERSION=3.31.10

RUN mkdir -p /opt/CMake-build/${CMAKEVERSION} /opt/CMake/${CMAKEVERSION}/ && cd /opt/CMake-build/${CMAKEVERSION} \
  && wget https://github.com/Kitware/CMake/releases/download/v${CMAKEVERSION}/cmake-${CMAKEVERSION}-linux-${NUMC_BUILD_ARCH}.tar.gz \
  && tar -zxf cmake-${CMAKEVERSION}-linux-${NUMC_BUILD_ARCH}.tar.gz \
  && mv /opt/CMake-build/${CMAKEVERSION}/cmake-${CMAKEVERSION}-linux-${NUMC_BUILD_ARCH}/* /opt/CMake/${CMAKEVERSION}/ \
  && rm -r /opt/CMake-build

ENV PATH=/opt/CMake/${CMAKEVERSION}/bin:${PATH}
FROM buildbox_base AS extradeps_build

RUN mkdir -p /opt/buildbox

ENV CMAKE_PREFIX_PATH=/opt/buildbox

RUN mkdir -p /src/fmt /build/fmt
WORKDIR /src
RUN git clone --depth 1 --branch 10.2.1 https://github.com/fmtlib/fmt.git fmt
WORKDIR /build/fmt
RUN cmake /src/fmt -DFMT_INSTALL=ON \
                   -DFMT_DOC=OFF \
                   -DFMT_TEST=OFF \
                   -DBUILD_SHARED_LIBS=ON \
                   -DCMAKE_INSTALL_PREFIX=/opt/buildbox
RUN make install -j 4

RUN mkdir -p /src/spdlog /build/spdlog
WORKDIR /src
RUN git clone --depth 1 --branch v1.14.1 https://github.com/gabime/spdlog.git spdlog
WORKDIR /build/spdlog
RUN cmake /src/spdlog -DSPDLOG_COMPILED_LIB=ON \
                      -DSPDLOG_BUILD_SHARED=ON \
                      -DSPDLOG_FMT_EXTERNAL=ON \
                      -DSPDLOG_INSTALL=ON \
                              -DCMAKE_INSTALL_PREFIX=/opt/buildbox
RUN make install -j 4

RUN mkdir -p /src/yaml-cpp /build/yaml-cpp
WORKDIR /src
RUN git clone --depth 1 --branch master https://github.com/jbeder/yaml-cpp.git yaml-cpp
WORKDIR /build/yaml-cpp
RUN cmake /src/yaml-cpp -DYAML_CPP_INSTALL=ON \
                        -DYAML_CPP_BUILD_TESTS=OFF \
                        -DYAML_CPP_BUILD_CONTRIB=OFF \
                        -DYAML_BUILD_SHARED_LIBS=ON \
                                -DCMAKE_INSTALL_PREFIX=/opt/buildbox
RUN make install -j 4

RUN mkdir -p /src/pybind11 /build/pybind11
WORKDIR /src
RUN git clone --depth 1 --branch v2.13.6 https://github.com/pybind/pybind11.git pybind11
WORKDIR /build/pybind11
RUN cmake /src/pybind11 -DPYBIND11_INSTALL=ON \
                        -DPYBIND11_TEST=OFF \
                                -DCMAKE_INSTALL_PREFIX=/opt/buildbox
RUN make install -j 4

RUN mkdir -p /src/cpr /build/cpr
WORKDIR /src
RUN git clone --depth 1 --branch 1.10.4 https://github.com/libcpr/cpr.git cpr
WORKDIR /build/cpr
RUN cmake /src/cpr -DCPR_USE_SYSTEM_CURL=ON \
        -DCMAKE_INSTALL_PREFIX=/opt/buildbox
RUN make install -j 4

RUN mkdir -p /src/docopt /build/docopt
WORKDIR /src
RUN git clone --depth 1 --branch master https://github.com/docopt/docopt.cpp.git docopt
WORKDIR /build/docopt
RUN cmake /src/docopt \
        -DCMAKE_INSTALL_PREFIX=/opt/buildbox
RUN make install -j 4

RUN mkdir -p /src/Catch2 /build/Catch2
WORKDIR /src
RUN git clone --depth 1 --branch v3.3.2 https://github.com/catchorg/Catch2.git Catch2
WORKDIR /build/Catch2
RUN cmake /src/Catch2 \
        -DCMAKE_INSTALL_PREFIX=/opt/buildbox
RUN make install -j 4

RUN mkdir -p /src/ROOTEGPythia6 /build/ROOTEGPythia6
WORKDIR /src
RUN git clone --depth 1 https://github.com/luketpickering/ROOTEGPythia6.git ROOTEGPythia6
WORKDIR /build/ROOTEGPythia6
RUN cmake /src/ROOTEGPythia6
RUN make install -j 4

FROM buildbox_base

ENV fmt_ROOT=/opt/buildbox \
    spdlog_ROOT=/opt/buildbox \
    yaml_ROOT=/opt/buildbox \
    pybind11_ROOT=/opt/buildbox \
    cpr_ROOT=/opt/buildbox \
    docopt_ROOT=/opt/buildbox \
    Catch2_ROOT=/opt/buildbox \
    LD_LIBRARY_PATH=/opt/buildbox/lib64:/opt/buildbox/lib:/usr/lib64/root:${LD_LIBRARY_PATH} \
    PATH=/opt/buildbox/bin:${PATH}

COPY --from=extradeps_build /opt/buildbox /opt/buildbox

COPY --from=extradeps_build /build/ROOTEGPythia6/Linux/include/* /usr/include/root/
COPY --from=extradeps_build /build/ROOTEGPythia6/Linux/lib/* /usr/lib64/root/

