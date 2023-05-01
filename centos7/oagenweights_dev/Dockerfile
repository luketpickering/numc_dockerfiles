# syntax=docker/dockerfile:1
FROM picker24/psyche_3_73:centos_7 AS niwg_build
WORKDIR /

# Pull in NEUT
COPY --from=picker24/neut_550:centos_7 /opt/cernlib /opt/cernlib
ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT /opt/cernlib/2005

ENV NEUT_VERSION=5.5.0
COPY --from=picker24/neut_550:centos_7 /opt/neut /opt/neut
ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}
ENV PATH=${NEUT_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH}
ENV NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat
ENV NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards
ENV ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH}

ENV PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}

# build Prob3plusplus
WORKDIR /opt
RUN git clone https://github.com/rogerwendell/Prob3plusplus.git prob3plusplus-build
WORKDIR /opt/prob3plusplus-build
RUN make
RUN mkdir -p /opt/prob3plusplus/git-master
RUN mv /opt/prob3plusplus-build/{*.h,*.a,*.cmake,LICENSE} /opt/prob3plusplus/git-master/

ENV Prob3plusplus_ROOT=/opt/prob3plusplus/git-master

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

# build FSIFitter
ENV FSIFITTER_VERSION=22.05

RUN mkdir -p /opt/fsifitter
WORKDIR /opt/fsifitter
RUN --mount=type=ssh git clone git@github.com:t2k-software/FSIFitter.git ${FSIFITTER_VERSION}
WORKDIR /opt/fsifitter/${FSIFITTER_VERSION}
RUN git checkout 22.05
RUN ./build_octave.sh
ENV OCT_VERSION=5.2.0
ENV OCT_PREFIX=/opt/fsifitter/${FSIFITTER_VERSION}/octave/${OCT_VERSION}/Linux
ENV PATH=${OCT_PREFIX}/bin:${PATH}
ENV LD_LIBRARY_PATH=${OCT_PREFIX}/lib/octave/${OCT_VERSION}/:${LD_LIBRARY_PATH}
RUN CXXFLAGS=-std=c++11 make

WORKDIR /opt
RUN mv /opt/fsifitter /opt/fsifitter-build
RUN mkdir -p /opt/fsifitter/${FSIFITTER_VERSION}
RUN mv /opt/fsifitter-build/${FSIFITTER_VERSION}/{*.hxx,*.so} /opt/fsifitter/${FSIFITTER_VERSION}/

RUN mkdir -p /opt/fsifitter/${FSIFITTER_VERSION}/octave/${OCT_VERSION}
RUN mv /opt/fsifitter-build/${FSIFITTER_VERSION}/octave/${OCT_VERSION}/Linux /opt/fsifitter/${FSIFITTER_VERSION}/octave/${OCT_VERSION}/

ENV FSIFITTERROOT=/opt/fsifitter/${FSIFITTER_VERSION}
ENV LD_LIBRARY_PATH=${FSIFITTERROOT}:${LD_LIBRARY_PATH}

# build GEANTReWeight
ENV GEANTReWeight_VERSION=22.05

RUN mkdir -p /opt/geantreweight
WORKDIR /opt/geantreweight
RUN --mount=type=ssh git clone git@github.com:t2k-software/GEANTReWeight.git ${GEANTReWeight_VERSION}
WORKDIR /opt/geantreweight/${GEANTReWeight_VERSION}
RUN git checkout 22.05
RUN make

WORKDIR /opt
RUN mv /opt/geantreweight /opt/geantreweight-build
RUN mkdir -p /opt/geantreweight/${GEANTReWeight_VERSION}
RUN mv /opt/geantreweight-build/${GEANTReWeight_VERSION}/{*.h,*.so,*.cmake} /opt/geantreweight/${GEANTReWeight_VERSION}/
RUN mv /opt/geantreweight-build/${GEANTReWeight_VERSION}/inputs /opt/geantreweight/${GEANTReWeight_VERSION}/

ENV GEANTREWEIGHT=/opt/geantreweight/${GEANTReWeight_VERSION}
ENV GEANTReWeight_ROOT=${GEANTREWEIGHT}
ENV LD_LIBRARY_PATH=${GEANTReWeight_ROOT}:${LD_LIBRARY_PATH}

# build NIWG
ENV NIWG_VERSION=22.05

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:t2k-software/NIWGReWeight.git niwgreweight
WORKDIR /opt/niwgreweight
RUN git checkout 22.05

RUN mkdir -p /opt/niwgreweight-build
WORKDIR /opt/niwgreweight-build
RUN cmake /opt/niwgreweight \
	-DCMAKE_INSTALL_PREFIX=/opt/niwgreweight/${NIWG_VERSION}
RUN make VERBOSE=1 && make install

ENV NIWG_ROOT="/opt/niwgreweight/${NIWG_VERSION}"
ENV PATH=${NIWG_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NIWG_ROOT}/lib:${LD_LIBRARY_PATH}

# new build layer
FROM niwg_build AS t2krw_build
WORKDIR /

ENV T2KREWEIGHT_VERSION=22.05

RUN mkdir -p /opt/t2kreweight/${T2KREWEIGHT_VERSION}

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:t2k-software/T2KReWeight.git t2kreweight-src
WORKDIR /opt/t2kreweight-src
RUN git checkout 22.05

RUN mkdir -p /opt/t2kreweight-build
WORKDIR /opt/t2kreweight-build
RUN cmake /opt/t2kreweight-src \
	-DCMAKE_INSTALL_PREFIX=/opt/t2kreweight/${T2KREWEIGHT_VERSION} 
RUN make && make install

ENV T2KReWeight_ROOT="/opt/t2kreweight/${T2KREWEIGHT_VERSION}"
ENV PATH=${T2KReWeight_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${T2KReWeight_ROOT}/lib:${LD_LIBRARY_PATH}

# new build layer
FROM t2krw_build AS oagenweightsapps_build
WORKDIR /

ENV OAGENWEIGHTS_VERSION=git-feature-NDTunerApp

RUN mkdir -p /opt/oagenweightsapps/${OAGENWEIGHTS_VERSION}

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

WORKDIR /opt
RUN echo "invalidated cache"
RUN --mount=type=ssh git clone git@github.com:t2k-software/OAGenWeightsApps.git oagenweightsapps-src
WORKDIR /opt/oagenweightsapps-src
RUN git checkout feature/NDTunerApp

RUN mkdir -p /opt/oagenweightsapps-build
WORKDIR /opt/oagenweightsapps-build
RUN cmake /opt/oagenweightsapps-src \
	-DCMAKE_INSTALL_PREFIX=/opt/oagenweightsapps/${OAGENWEIGHTS_VERSION} 
RUN make && make install

ENV OAGENWEIGHTSROOT="/opt/oagenweightsapps/${OAGENWEIGHTS_VERSION}"
ENV PATH=${OAGENWEIGHTSROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${OAGENWEIGHTSROOT}/lib:${LD_LIBRARY_PATH}

# new layer
FROM picker24/psyche_3_73:centos_7
WORKDIR /

# Pull in NEUT
COPY --from=picker24/neut_550:centos_7 /opt/cernlib /opt/cernlib
ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT /opt/cernlib/2005

ENV NEUT_VERSION=5.5.0
COPY --from=picker24/neut_550:centos_7 /opt/neut /opt/neut
ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}
ENV PATH=${NEUT_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH}
ENV NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat
ENV NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards
ENV ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH}

ENV Prob3plusplus_ROOT=/opt/prob3plusplus/git-master
COPY --from=niwg_build ${Prob3plusplus_ROOT} ${Prob3plusplus_ROOT}

ENV FSIFITTER_VERSION=22.05
ENV FSIFITTERROOT=/opt/fsifitter/${FSIFITTER_VERSION}

ENV OCT_VERSION=5.2.0
ENV OCT_PREFIX=/opt/fsifitter/${FSIFITTER_VERSION}/octave/${OCT_VERSION}/Linux
ENV PATH=${OCT_PREFIX}/bin:${PATH}
ENV LD_LIBRARY_PATH=${OCT_PREFIX}/lib/octave/${OCT_VERSION}/:${LD_LIBRARY_PATH}

COPY --from=niwg_build ${FSIFITTERROOT} ${FSIFITTERROOT}
ENV LD_LIBRARY_PATH=${FSIFITTERROOT}:${LD_LIBRARY_PATH}

ENV GEANTReWeight_VERSION=22.05
ENV GEANTREWEIGHT=/opt/geantreweight/${GEANTReWeight_VERSION}
ENV GEANTReWeight_ROOT=${GEANTREWEIGHT}
COPY --from=niwg_build ${GEANTReWeight_ROOT} ${GEANTReWeight_ROOT}
ENV LD_LIBRARY_PATH=${GEANTReWeight_ROOT}:${LD_LIBRARY_PATH}

ENV PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}

RUN mkdir /opt/niwgreweight
ENV NIWG_VERSION=22.05
COPY --from=t2krw_build /opt/niwgreweight/${NIWG_VERSION} /opt/niwgreweight/${NIWG_VERSION}
ENV NIWG_ROOT="/opt/niwgreweight/${NIWG_VERSION}"
ENV PATH=${NIWG_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NIWG_ROOT}/lib:${LD_LIBRARY_PATH}
RUN ln -s ${NIWG_ROOT}/include /opt/niwgreweight/src

COPY --from=t2krw_build /opt/t2kreweight /opt/t2kreweight
ENV T2KREWEIGHT_VERSION=22.05
ENV T2KReWeight_ROOT="/opt/t2kreweight/${T2KREWEIGHT_VERSION}"
ENV PATH=${T2KReWeight_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${T2KReWeight_ROOT}/lib:${LD_LIBRARY_PATH}

COPY --from=oagenweightsapps_build /opt/oagenweightsapps /opt/oagenweightsapps
ENV OAGENWEIGHTS_VERSION=git-feature-NDTunerApp
ENV OAGENWEIGHTSROOT="/opt/oagenweightsapps/${OAGENWEIGHTS_VERSION}"
ENV PATH=${OAGENWEIGHTSROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${OAGENWEIGHTSROOT}/lib:${LD_LIBRARY_PATH}
