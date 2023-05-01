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

ENV NEUT_VERSION=oa2020

RUN mkdir -p /opt/neut/${NEUT_VERSION} /opt/neut-build
RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:neut-devel/neut.git neut-src
WORKDIR /opt/neut-src
RUN git checkout OA2020PythiaPatch
WORKDIR /opt/neut-src/src
RUN find . -name trapfpe.c -exec sed -i "s/(_FPU_DEFAULT & ~_FPU_EXTENDED) | _FPU_DOUBLE/_FPU_DEFAULT/g" \{} \;
RUN autoreconf -if

WORKDIR /opt/neut-build
RUN /opt/neut-src/src/configure --prefix=/opt/neut/${NEUT_VERSION}
RUN make install -j 4

FROM picker24/root_v6_24_06:centos_7
WORKDIR /

COPY --from=neut_build /opt/cernlib /opt/cernlib
ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT /opt/cernlib/2005

ENV NEUT_VERSION=oa2020
COPY --from=neut_build /opt/neut /opt/neut
ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}
ENV NEUT=/opt/neut/${NEUT_VERSION}
ENV PATH=${NEUT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NEUT}/lib:${LD_LIBRARY_PATH}
ENV NEUT_CRSPATH=/opt/neut/${NEUT_VERSION}/share/neut/crsdat
ENV NEUT_CARDS=/opt/neut/${NEUT_VERSION}/share/neut/Cards
