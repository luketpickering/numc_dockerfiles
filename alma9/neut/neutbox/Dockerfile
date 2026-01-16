# syntax=docker/dockerfile:1
FROM picker24/root_v6_30_04:alma9 AS neut_build
WORKDIR /

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

RUN mkdir -p /opt/neut

# 5.4.0.1 -------------
RUN mkdir -p /opt/cernlib-src /opt/cernlib/2005
WORKDIR /opt/cernlib-src
RUN test -e /usr/bin/gmake || ln -s /usr/bin/make /usr/bin/gmake
RUN git clone https://github.com/luketpickering/cernlibgcc5-.git
WORKDIR /opt/cernlib-src/cernlibgcc5-
RUN ./build_cernlib.sh
RUN cp -r /opt/cernlib-src/cernlibgcc5-/cernlib_build/2005/bin \
    /opt/cernlib-src/cernlibgcc5-/cernlib_build/2005/lib \
    /opt/cernlib-src/cernlibgcc5-/cernlib_build/2005/include \
    /opt/cernlib/2005

ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT /opt/cernlib/2005

ENV NEUT_VERSION=5.4.0.1

WORKDIR /opt/neut
WORKDIR /opt/cernlib
WORKDIR /opt/neut
RUN --mount=type=ssh git clone git@github.com:neut-devel/neut.git ${NEUT_VERSION}
WORKDIR /opt/neut/${NEUT_VERSION}
RUN git checkout ${NEUT_VERSION}

ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}

WORKDIR /opt/neut/${NEUT_VERSION}/src
RUN mkdir -p {ht2p2h,n1p1h}/{bin,lib}
RUN sed -i "s/-m64/-march=native/g" n1p1h/Makefile ht2p2h/Makefile

WORKDIR /opt/neut/${NEUT_VERSION}/src/neutsmpl
RUN sed -i "s/(_FPU_DEFAULT & ~_FPU_EXTENDED) | _FPU_DOUBLE/_FPU_DEFAULT/g" trapfpe.c

ENV FC=gfortran \
    ROOTSYS=/usr \
    PATH=/opt/cernlib/2005/bin:${PATH}
RUN sed -i "s/FCOPTIONS =/FCOPTIONS = -fallow-argument-mismatch -fcommon -Wl,--allow-multiple-definition/g" config_gfortran_nopie.gmk
RUN sed -i "s/CERNLIBS    =/CERNLIBS    = -Wl,--allow-multiple-definition/g" config_gfortran_nopie.gmk
RUN ./Makeneutsmpl

WORKDIR /opt/neut/${NEUT_VERSION}/src/reweight
RUN sed -i "s/5.3.6/5.4.0/g" GNUmakefile
RUN sed -i "s/536/540/g" GNUmakefile
RUN sed -i "s/5.3.5/5.4.0/g" GNUmakefile
RUN sed -i "s/535/540/g" GNUmakefile
RUN sed -i 's/$(RM)/-$(RM)/g' GNUmakefile
RUN sed -i 's/nuccorrspl/nuccorspl/g' GNUmakefile
RUN sed -i 's/isinf/std::isinf/g' NReWeightCasc.cc NReWeightNuXSecCCQE.cc NReWeightNuXSecCCRES.cc NReWeightNuXSecCOH.cc NReWeightNuXSecDIS.cc NReWeightNuXSecRES.cc NReWeightNuXSecNCEL.cc NReWeightNuXSecNCRES.cc
RUN sed -i 's/isnan/std::isnan/g' NReWeightCasc.cc NReWeightNuXSecCCQE.cc NReWeightNuXSecCCRES.cc NReWeightNuXSecCOH.cc NReWeightNuXSecDIS.cc NReWeightNuXSecRES.cc NReWeightNuXSecNCEL.cc NReWeightNuXSecNCRES.cc
ENV PATH=${CERN_ROOT}/bin:${PATH}
RUN ln -s /opt/neut/${NEUT_VERSION}/lib /opt/neut/${NEUT_VERSION}/lib/Linux_pc
RUN make all

RUN mkdir -p /opt/neut-build/${NEUT_VERSION}
WORKDIR /opt/neut-build/${NEUT_VERSION}
RUN git clone https://github.com/neut-devel/neutvect-converter.git

ADD 5.4.0.1/FindNEUT.cmake /opt/neut-build/${NEUT_VERSION}/neutvect-converter/cmake/Modules

WORKDIR /opt/neut-build/${NEUT_VERSION}/neutvect-converter
RUN sed -i "s/5.5.0/5.4.0/g" CMakeLists.txt

WORKDIR /opt/neut-build/${NEUT_VERSION}/neutvect-converter/src
RUN grep -v "NEUT.RADcorr" nvconv.cxx > nvconv.cxx.n
RUN mv nvconv.cxx.n nvconv.cxx

RUN mkdir /opt/neut-build/${NEUT_VERSION}/neutvect-converter/build
WORKDIR /opt/neut-build/${NEUT_VERSION}/neutvect-converter/build
RUN cmake ../ -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/opt/neut/${NEUT_VERSION}
RUN make install -j 4

ADD neut-quickstart /opt/neut/${NEUT_VERSION}/bin
RUN chmod +x /opt/neut/${NEUT_VERSION}/bin/neut-quickstart

# # 5.6.4.3 -------------
# ENV NEUT_VERSION=5.6.4.3

# WORKDIR /opt/neut
# RUN --mount=type=ssh git clone --branch t2k/5.6.4.3 --depth 1 git@github.com:neut-devel/neut.git ${NEUT_VERSION}
# WORKDIR /opt/neut/${NEUT_VERSION}/src
# RUN find . -name trapfpe.c -exec sed -i "s/(_FPU_DEFAULT & ~_FPU_EXTENDED) | _FPU_DOUBLE/_FPU_DEFAULT/g" \{} \;
# RUN autoreconf -if

# RUN mkdir -p /opt/neut-build/${NEUT_VERSION}
# WORKDIR /opt/neut-build/${NEUT_VERSION}
# RUN /opt/neut/${NEUT_VERSION}/src/configure --prefix=/opt/neut/${NEUT_VERSION} --enable-builtin-cernlib --enable-debug
# RUN CERNLIB_NJOBS="-j 4" make install
# RUN sed -i "s:PATHS \${NEUT_PREFIX}:PATHS \${NEUT_PREFIX}/bin:g" /opt/neut/5.6.4.3/cmake/NEUTConfig.cmake

# ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION} \
#     PKG_CONFIG_PATH=/opt/neut/${NEUT_VERSION}

# RUN git clone https://github.com/neut-devel/neutvect-converter.git

# RUN mkdir /opt/neut-build/${NEUT_VERSION}/neutvect-converter/build
# WORKDIR /opt/neut-build/${NEUT_VERSION}/neutvect-converter/build
# RUN cmake ../ -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/opt/neut/${NEUT_VERSION}
# RUN make install -j 4

# ADD neut-quickstart /opt/neut/${NEUT_VERSION}/bin
# RUN chmod +x /opt/neut/${NEUT_VERSION}/bin/neut-quickstart

# # 5.8.0 -------------
# ENV NEUT_VERSION=5.8.0

# WORKDIR /opt/neut
# RUN --mount=type=ssh git clone --branch 5.8.0 --depth 1 git@github.com:neut-devel/neut.git ${NEUT_VERSION}
# WORKDIR /opt/neut/${NEUT_VERSION}/src
# RUN git submodule update --init
# RUN find . -name trapfpe.c -exec sed -i "s/(_FPU_DEFAULT & ~_FPU_EXTENDED) | _FPU_DOUBLE/_FPU_DEFAULT/g" \{} \;
# RUN autoreconf -if

# RUN mkdir -p /opt/neut-build/${NEUT_VERSION}
# WORKDIR /opt/neut-build/${NEUT_VERSION}
# RUN /opt/neut/${NEUT_VERSION}/src/configure --prefix=/opt/neut/${NEUT_VERSION} --enable-builtin-cernlib --enable-debug
# RUN CERNLIB_NJOBS="-j 4" make install
# RUN sed -i "s:PATHS \${NEUT_PREFIX}:PATHS \${NEUT_PREFIX}/bin:g" /opt/neut/5.8.0/cmake/NEUTConfig.cmake

# ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION} \
#     PKG_CONFIG_PATH=/opt/neut/${NEUT_VERSION}

# RUN git clone https://github.com/neut-devel/neutvect-converter.git

# RUN mkdir /opt/neut-build/${NEUT_VERSION}/neutvect-converter/build
# WORKDIR /opt/neut-build/${NEUT_VERSION}/neutvect-converter/build
# RUN cmake ../ -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/opt/neut/${NEUT_VERSION}
# RUN make install -j 4

# ADD neut-quickstart /opt/neut/${NEUT_VERSION}/bin
# RUN chmod +x /opt/neut/${NEUT_VERSION}/bin/neut-quickstart

# # 5.9.1 -------------
# ENV NEUT_VERSION=5.9.1

# WORKDIR /opt/neut
# RUN --mount=type=ssh git clone --branch 5.9.1 --depth 1 git@github.com:neut-devel/neut.git ${NEUT_VERSION}
# WORKDIR /opt/neut/${NEUT_VERSION}/src
# RUN git submodule update --init
# RUN find . -name trapfpe.c -exec sed -i "s/(_FPU_DEFAULT & ~_FPU_EXTENDED) | _FPU_DOUBLE/_FPU_DEFAULT/g" \{} \;
# RUN autoreconf -if

# RUN mkdir -p /opt/neut-build/${NEUT_VERSION}
# WORKDIR /opt/neut-build/${NEUT_VERSION}
# RUN /opt/neut/${NEUT_VERSION}/src/configure \
#   --prefix=/opt/neut/${NEUT_VERSION} \
#   --enable-builtin-cernlib \
#   --enable-debug
# RUN CERNLIB_NJOBS="-j 4" make install

# ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}

# RUN git clone https://github.com/neut-devel/neutvect-converter.git

# RUN mkdir /opt/neut-build/${NEUT_VERSION}/neutvect-converter/build
# WORKDIR /opt/neut-build/${NEUT_VERSION}/neutvect-converter/build
# RUN cmake ../ -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/opt/neut/${NEUT_VERSION}
# RUN make install -j 4

# ADD neut-quickstart /opt/neut/${NEUT_VERSION}/bin
# RUN chmod +x /opt/neut/${NEUT_VERSION}/bin/neut-quickstart

#final image
FROM picker24/root_v6_30_04:alma9
WORKDIR /

COPY --from=neut_build /opt/neut /opt/neut

RUN mkdir -p /opt/neut/utils
ADD neut-switcher /opt/neut/utils/

RUN chmod +x /opt/neut/utils/*
ENV PATH=/opt/neut/utils/:${PATH} \
    OMP_NUM_THREADS=1

ENV ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH}
