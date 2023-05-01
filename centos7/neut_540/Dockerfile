# syntax=docker/dockerfile:1
FROM picker24/buildbox:centos_7 AS cernlib_build
WORKDIR /

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

FROM picker24/root_v6_24_06:centos_7 AS neut_build
WORKDIR /

COPY --from=cernlib_build /opt/cernlib /opt/cernlib
ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT /opt/cernlib/2005

ENV NEUT_VERSION=5.4.0

RUN mkdir -p /opt/neut
WORKDIR /opt/neut
RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts
RUN --mount=type=ssh git clone git@github.com:neut-devel/neut.git ${NEUT_VERSION}
WORKDIR /opt/neut/${NEUT_VERSION}
RUN git checkout ${NEUT_VERSION}

ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}

WORKDIR /opt/neut/${NEUT_VERSION}/src
RUN mkdir -p {ht2p2h,n1p1h}/{bin,lib}
RUN sed -i "s/-m64//g" n1p1h/Makefile ht2p2h/Makefile

WORKDIR /opt/neut/${NEUT_VERSION}/src/neutsmpl
RUN sed -i "s/(_FPU_DEFAULT & ~_FPU_EXTENDED) | _FPU_DOUBLE/_FPU_DEFAULT/g" trapfpe.c

ENV FC=gfortran
RUN ./Makeneutsmpl

WORKDIR /opt/neut/${NEUT_VERSION}/src/reweight
RUN sed -i "s/5.3.6/5.4.0/g" GNUmakefile
RUN sed -i "s/536/540/g" GNUmakefile
RUN sed -i "s/5.3.5/5.4.0/g" GNUmakefile
RUN sed -i "s/535/540/g" GNUmakefile
RUN sed -i 's/$(RM)/-$(RM)/g' GNUmakefile
RUN sed -i 's/nuccorrspl/nuccorspl/g' GNUmakefile
ENV PATH=${CERN_ROOT}/bin:${PATH}
RUN ln -s /opt/neut/${NEUT_VERSION}/lib /opt/neut/${NEUT_VERSION}/lib/Linux_pc
RUN make all

FROM picker24/root_v6_24_06:centos_7
WORKDIR /

COPY --from=neut_build /opt/cernlib /opt/cernlib
ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT /opt/cernlib/2005

ENV NEUT_VERSION=5.4.0
RUN mkdir -p /opt/neut/${NEUT_VERSION}/src
COPY --from=neut_build /opt/neut/${NEUT_VERSION}/lib /opt/neut/${NEUT_VERSION}/lib
COPY --from=neut_build /opt/neut/${NEUT_VERSION}/include /opt/neut/${NEUT_VERSION}/include
COPY --from=neut_build /opt/neut/${NEUT_VERSION}/src/crsdat /opt/neut/${NEUT_VERSION}/src/crsdat
COPY --from=neut_build /opt/neut/${NEUT_VERSION}/src/reweight /opt/neut/${NEUT_VERSION}/src/reweight
COPY --from=neut_build /opt/neut/${NEUT_VERSION}/src/neutsmpl /opt/neut/${NEUT_VERSION}/src/neutsmpl
COPY --from=neut_build /opt/neut/${NEUT_VERSION}/src/neutclass /opt/neut/${NEUT_VERSION}/src/neutclass
ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}
ENV NEUT_CRSPATH=/opt/neut/${NEUT_VERSION}/src/crsdat
ENV NEUT_CARDS=/opt/neut/${NEUT_VERSION}/src/neutsmpl/Cards