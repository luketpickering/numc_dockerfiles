# syntax=docker/dockerfile:1
FROM picker24/root_v6_28_08:alma9 AS geantrw_build
WORKDIR /

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

# build FSIFitter
ENV FSIFITTER_VERSION=22.05

RUN mkdir -p /opt/fsifitter
WORKDIR /opt/fsifitter
RUN --mount=type=ssh git clone git@github.com:t2k-software/FSIFitter.git ${FSIFITTER_VERSION}
WORKDIR /opt/fsifitter/${FSIFITTER_VERSION}
RUN git checkout ${FSIFITTER_VERSION}
RUN ./build_octave.sh
ENV OCT_VERSION=5.2.0 
ENV OCT_PREFIX=/opt/fsifitter/${FSIFITTER_VERSION}/octave/${OCT_VERSION}/Linux 
ENV PATH=${OCT_PREFIX}/bin:${PATH} 
ENV LD_LIBRARY_PATH=${OCT_PREFIX}/lib/octave/${OCT_VERSION}/:${LD_LIBRARY_PATH}
RUN CXXFLAGS=-std=c++17 make

WORKDIR /opt
RUN mv /opt/fsifitter /opt/fsifitter-build
RUN mkdir -p /opt/fsifitter/${FSIFITTER_VERSION}
RUN mv /opt/fsifitter-build/${FSIFITTER_VERSION}/{*.hxx,*.so} /opt/fsifitter/${FSIFITTER_VERSION}/

RUN mkdir -p /opt/fsifitter/${FSIFITTER_VERSION}/octave/${OCT_VERSION}
RUN mv /opt/fsifitter-build/${FSIFITTER_VERSION}/octave/${OCT_VERSION}/Linux /opt/fsifitter/${FSIFITTER_VERSION}/octave/${OCT_VERSION}/

ENV FSIFITTERROOT=/opt/fsifitter/${FSIFITTER_VERSION}
ENV LD_LIBRARY_PATH=${FSIFITTERROOT}:${LD_LIBRARY_PATH}

WORKDIR /opt/fsifitter-build/${FSIFITTER_VERSION}
RUN git rev-parse --short HEAD > /opt/fsifitter/${FSIFITTER_VERSION}/git.shorthash

# build GEANTReWeight
ENV GEANTReWeight_VERSION=23.10

RUN mkdir -p /opt/geantreweight
WORKDIR /opt/geantreweight
RUN --mount=type=ssh git clone git@github.com:t2k-software/GEANTReWeight.git ${GEANTReWeight_VERSION}
WORKDIR /opt/geantreweight/${GEANTReWeight_VERSION}
RUN git checkout develop
RUN make

WORKDIR /opt
RUN mv /opt/geantreweight /opt/geantreweight-build
RUN mkdir -p /opt/geantreweight/${GEANTReWeight_VERSION}
RUN mv /opt/geantreweight-build/${GEANTReWeight_VERSION}/{*.h,*.so,*.cmake} /opt/geantreweight/${GEANTReWeight_VERSION}/
RUN mv /opt/geantreweight-build/${GEANTReWeight_VERSION}/inputs /opt/geantreweight/${GEANTReWeight_VERSION}/

ENV GEANTREWEIGHT=/opt/geantreweight/${GEANTReWeight_VERSION}
ENV GEANTReWeight_ROOT=${GEANTREWEIGHT}
ENV LD_LIBRARY_PATH=${GEANTReWeight_ROOT}:${LD_LIBRARY_PATH}

WORKDIR /opt/geantreweight-build/${GEANTReWeight_VERSION}
RUN git rev-parse --short HEAD > /opt/geantreweight/${GEANTReWeight_VERSION}/git.shorthash

# Final image
FROM picker24/root_v6_28_08:alma9
WORKDIR /

COPY --from=geantrw_build /opt/fsifitter /opt/fsifitter
COPY --from=geantrw_build /opt/geantreweight /opt/geantreweight

ENV FSIFITTER_VERSION=22.05 \
    OCT_VERSION=5.2.0 \
    GEANTReWeight_VERSION=23.10

ENV OCT_PREFIX=/opt/fsifitter/${FSIFITTER_VERSION}/octave/${OCT_VERSION}/Linux \
    FSIFITTERROOT=/opt/fsifitter/${FSIFITTER_VERSION} \
    GEANTREWEIGHT=/opt/geantreweight/${GEANTReWeight_VERSION}

ENV GEANTReWeight_ROOT=${GEANTREWEIGHT} \
    PATH=${OCT_PREFIX}/bin:${PATH} \
    LD_LIBRARY_PATH=${GEANTREWEIGHT}:${FSIFITTERROOT}:${OCT_PREFIX}/lib/octave/${OCT_VERSION}:${LD_LIBRARY_PATH}
