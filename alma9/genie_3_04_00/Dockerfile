# syntax=docker/dockerfile:1
FROM picker24/buildbox:alma9 AS lhapdf_build
WORKDIR /

RUN mkdir -p /opt/lhapdf-src
WORKDIR /opt/lhapdf-src

ENV LHAPDF_VERS=5.9.1

RUN wget https://lhapdf.hepforge.org/downloads/?f=old/lhapdf-${LHAPDF_VERS}.tar.gz \
         -O lhapdf-${LHAPDF_VERS}.tar.gz \
    && tar -zxvf lhapdf-${LHAPDF_VERS}.tar.gz

WORKDIR /opt/lhapdf-src/lhapdf-5.9.1/config/
RUN  wget -O config.guess 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD' \
 && wget -O config.sub 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD'

RUN mkdir -p /opt/lhapdf-build /opt/lhapdf/${LHAPDF_VERS}
WORKDIR /opt/lhapdf-build

ENV FCFLAGS="-std=legacy"
RUN /opt/lhapdf-src/lhapdf-${LHAPDF_VERS}/configure \
                                    --prefix=/opt/lhapdf/${LHAPDF_VERS} \
                                    --disable-old-ccwrap \
                                    --disable-pyext \
    && make install -j 3

FROM picker24/root_v6_28_08:alma9 AS genie_build
WORKDIR /

COPY --from=lhapdf_build /opt/lhapdf/ /opt/lhapdf/
ENV LHAPDF_VERS=5.9.1
ENV LHAPATH=/opt/lhapdf/${LHAPDF_VERS}
ENV PATH=${LHAPATH}/bin:${PATH}
ENV LD_LIBRARY_PATH=${LHAPATH}/lib:${LD_LIBRARY_PATH}
ENV LHAPDF_INC=${LHAPATH}/include
ENV LHAPDF_LIB=${LHAPATH}/lib

ENV GENIE_VERSION=3_04_00
ENV GENIE_REWEIGHT_VERSION=1_02_02

WORKDIR /opt/
RUN git clone https://github.com/GENIE-MC/Generator.git Generator-src
WORKDIR /opt/Generator-src
RUN git checkout R-${GENIE_VERSION}
WORKDIR /opt/
RUN git clone https://github.com/luketpickering/Reweight.git Reweight-src
WORKDIR /opt/Reweight-src
# RUN git checkout R-${GENIE_REWEIGHT_VERSION}

ENV GENIE=/opt/Generator-src

WORKDIR /opt/Generator-src
RUN mkdir -p /opt/genie/${GENIE_VERSION} \
 && ./configure --prefix=/opt/genie/${GENIE_VERSION} \
 && make -j 3 && make install

ENV GENIE_REWEIGHT=/opt/Reweight-src/
WORKDIR /opt/Reweight-src
RUN make && make install

RUN cp /opt/Generator-src/data/evgen/pdfs/GRV98lo_patched.LHgrid \
    ${LHAPATH}/GRV98lo_patched.LHgrid

ENV GENIE="/opt/genie/${GENIE_VERSION}"
ENV GENIE_REWEIGHT=${GENIE}

# Install some things that the GENIE install script forget.
RUN cp /opt/Generator-src/VERSION ${GENIE}/
RUN cp -r /opt/Generator-src/config ${GENIE}/
RUN mkdir -p ${GENIE}/data/
RUN cp -r /opt/Generator-src/data/evgen ${GENIE}/data/

RUN mkdir -p ${GENIE}/src/make/
RUN cp /opt/Generator-src/src/make/Make.config_no_paths \
                      ${GENIE}/src/make/

WORKDIR ${GENIE}/src
RUN ln -s -t . ../include/GENIE/*/

## Final container
FROM picker24/root_v6_28_08:alma9

COPY --from=lhapdf_build /opt/lhapdf /opt/lhapdf
ENV LHAPDF_VERS=5.9.1 
ENV LHAPATH=/opt/lhapdf/${LHAPDF_VERS}
ENV PATH=${LHAPATH}/bin:${PATH} \
    LD_LIBRARY_PATH=${LHAPATH}/lib:${LD_LIBRARY_PATH} \
    LHAPDF_INC=${LHAPATH}/include \
    LHAPDF_LIB=${LHAPATH}/lib

COPY --from=genie_build /opt/genie /opt/genie
ENV GENIE_VERSION=3_04_00 \
    GENIE_REWEIGHT_VERSION=1_02_02
ENV GENIE="/opt/genie/${GENIE_VERSION}"
ENV GENIE_REWEIGHT=${GENIE}

RUN mkdir -p /opt/genie/utils/
ADD  genie_fetch_tune \
     genie_set_tune \
     genie_list_tunes \
     gxspl.min.awk \
  /opt/genie/utils/

ENV PATH=${GENIE}/bin:/opt/genie/utils/:${PATH} \
    LD_LIBRARY_PATH=${GENIE_REWEIGHT}/lib:${GENIE}/lib:${LD_LIBRARY_PATH} \
    ROOT_INCLUDE_PATH=${GENIE}/include/GENIE:${ROOT_INCLUDE_PATH}

RUN /opt/genie/utils/genie_fetch_tune ${GENIE_VERSION} AR23_20i_00_000 \
    && /opt/genie/utils/genie_fetch_tune ${GENIE_VERSION} G18_10a_02_11b \
    && /opt/genie/utils/genie_fetch_tune ${GENIE_VERSION} G21_11a_00_000

ENV GENIE_XSEC_TUNE=AR23_20i_00_000 \
    GENIE_XSEC_DIR=/opt/genie_xsec/3_04_00/AR23_20i_00_000 \
    GENIE_XSEC_FILE=/opt/genie_xsec/3_04_00/AR23_20i_00_000/gxspl-min.xml.gz \
    GENIE_REWEIGHT=/opt/genie/3_04_00 \
    GENIE_VERSION=3_04_00 \
    GENIE_PHYOPT_DIR=/opt/genie_phyopt/3_04_00/dkcharmtau \
    GXMLPATH=/opt/genie_phyopt/3_04_00/dkcharmtau:/opt/genie_xsec/3_04_00/AR23_20i_00_000
