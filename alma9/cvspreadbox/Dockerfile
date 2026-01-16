# syntax=docker/dockerfile:1
FROM picker24/genbox:alma9 as build

# update GENIE splines
RUN wget https://scisoft.fnal.gov/scisoft/packages/genie_xsec/v3_04_00/genie_xsec-3.04.00-noarch-AR2320i00000-k250-e1000.tar.bz2
RUN bunzip2 genie_xsec-3.04.00-noarch-AR2320i00000-k250-e1000.tar.bz2
RUN tar -xvf genie_xsec-3.04.00-noarch-AR2320i00000-k250-e1000.tar
RUN cp genie_xsec/v3_04_00/NULL/AR2320i00000-k250-e1000/data/gxspl-FNALbig.xml.gz /opt/genie_xsec/3_04_00/AR23_20i_00_000/

# build NUISANCE2
RUN mkdir -p /opt/nuisance
WORKDIR /opt/nuisance
RUN git clone https://github.com/NUISANCEMC/nuisance.git nuisance2
RUN mkdir -p /opt/nuisance/nuisance2/build
WORKDIR /opt/nuisance/nuisance2/build
RUN cmake .. -DNuHepMC_ENABLED=ON
RUN make install 

# build nusystematics
ENV PYTHIA6_LIB_DIR=/usr/lib64/root

WORKDIR /opt
RUN git clone --depth  1 https://github.com/luketpickering/fhicl-cpp-standalone.git fhicl-cpp-standalone-src
RUN mkdir -p /opt/fhicl-cpp-standalone-build
WORKDIR /opt/fhicl-cpp-standalone-build
RUN cmake /opt/fhicl-cpp-standalone-src -DCMAKE_INSTALL_PREFIX=/opt/fhicl-cpp-standalone
RUN make install -j 4
ENV CMAKE_PREFIX_PATH=/opt/fhicl-cpp-standalone:${CMAKE_PREFIX_PATH}

WORKDIR /opt
RUN git clone --depth 1 --branch feature/cvspread https://github.com/luketpickering/nusystematics_standalone.git nusystematics-src
RUN mkdir -p /opt/nusystematics-build
WORKDIR /opt/nusystematics-build
RUN cmake /opt/nusystematics-src -DCMAKE_INSTALL_PREFIX=/opt/nusystematics/v02_00_05
RUN make install -j 4
WORKDIR /opt/nusystematics-src
RUN git rev-parse --short HEAD > /opt/nusystematics/git.shorthash

ENV nusystematics_ROOT=/opt/nusystematics/v02_00_05 \
    nusystematics_VERSION=02_00_05 \
    NUISANCE=/opt/nuisance/nuisance2/build/Linux/ \
    CMAKE_PREFIX_PATH=/opt/fhicl-cpp-standalone:${CMAKE_PREFIX_PATH}

# build NUISANCE3
WORKDIR /opt/nuisance
RUN git clone https://github.com/NUISANCEMC/nuisance3.git nuisance3-src
RUN mkdir -p /opt/nuisance/nuisance3-build
WORKDIR /opt/nuisance/nuisance3-build
RUN cmake /opt/nuisance/nuisance3-src -DNUISANCE_USE_ARROW=ON -DNUISANCE_LEGACY_INTERFACE=ON -DCMAKE_INSTALL_PREFIX=/opt/nuisance/nuisance3
RUN make install

FROM picker24/genbox:alma9
WORKDIR /

COPY --from=build /opt/nusystematics /opt/nusystematics
COPY --from=build /opt/fhicl-cpp-standalone /opt/fhicl-cpp-standalone
COPY --from=build /opt/genie_xsec/3_04_00/AR23_20i_00_000/gxspl-FNALbig.xml.gz /opt/genie_xsec/3_04_00/AR23_20i_00_000/
COPY --from=build /opt/nuisance/nuisance2 /opt/nuisance/nuisance2
COPY --from=build /opt/nuisance/nuisance3 /opt/nuisance/nuisance3
ENV nusystematics_ROOT=/opt/nusystematics/v02_00_05 \
    nusystematics_VERSION=02_00_05 \
    ProSelecta_ROOT=/opt/nuisance/nuisance3 \
    ProSelecta_INCLUDE_PATH=/opt/nuisance/nuisance3/include:/opt/HepMC3/3.3.2/include \
    NUISANCE3_ROOT=/opt/nuisance/nuisance3 \
    NUISANCE3_VERSION=3.0.1 \
    NUISANCE=/opt/nuisance/nuisance2/build/Linux/ \
    CMAKE_PREFIX_PATH=/opt/fhicl-cpp-standalone:${CMAKE_PREFIX_PATH} \
    PATH=/opt/nuisance/nuisance2/build/Linux/bin:/opt/nuisance/nuisance3/bin:/opt/nusystematics/v02_00_05/bin:/opt/fhicl-cpp-standalone/bin:${PATH} \
    LD_LIBRARY_PATH=/opt/nuisance/nuisance2/build/Linux/lib:/opt/nuisance/nuisance3/lib:/opt/nusystematics/v02_00_05/lib:/opt/fhicl-cpp-standalone/lib:/opt/fhicl-cpp-standalone/libexec:${LD_LIBRARY_PATH} \
    PYTHONPATH=/opt/nuisance/nuisance3/python/3.9:/opt/nuisance/nuisance3/lib:${PYTHONPATH}
