# syntax=docker/dockerfile:1
FROM picker24/buildbox:debian_bullseye-slim AS lhapdf_build
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
    && make install -j 5

FROM picker24/root_v6_24_06:debian_bullseye-slim AS genie_build
WORKDIR /

ENV GENIE_XSEC_TUNE_COMPRESSED=N1810j0211a
ENV GENIE_XSEC_TUNE=N18_10j_02_11a

RUN wget https://scisoft.fnal.gov/scisoft/packages/genie_xsec/v3_00_06/genie_xsec-3.00.06-noarch-${GENIE_XSEC_TUNE_COMPRESSED}-k250-e1000-resfix.tar.bz2 \
          -O genie_xsec-3.00.06-noarch-${GENIE_XSEC_TUNE_COMPRESSED}-k250-e1000-resfix.tar.bz2
RUN tar xvf genie_xsec-3.00.06-noarch-${GENIE_XSEC_TUNE_COMPRESSED}-k250-e1000-resfix.tar.bz2
RUN mv genie_xsec/v3_00_06/NULL/${GENIE_XSEC_TUNE_COMPRESSED}-k250-e1000-resfix/data/gxspl-NUsmall.xml ./
COPY gxspl.min.awk /
RUN awk -f gxspl.min.awk gxspl-NUsmall.xml > gxspl-min.xml
RUN gzip gxspl-min.xml

RUN wget https://scisoft.fnal.gov/scisoft/packages/genie_phyopt/v3_00_06/genie_phyopt-3.00.06-noarch-dkcharmtau-resfix.tar.bz2 \
    -O genie_phyopt-3.00.06-noarch-dkcharmtau-resfix.tar.bz2
RUN tar xvf genie_phyopt-3.00.06-noarch-dkcharmtau-resfix.tar.bz2
RUN cp -r genie_phyopt/v3_00_06/NULL/dkcharmtau-resfix .
RUN rm -r genie_phyopt dkcharmtau-resfix/ups

COPY --from=lhapdf_build /opt/lhapdf/ /opt/lhapdf/
ENV LHAPDF_VERS=5.9.1
ENV LHAPATH=/opt/lhapdf/${LHAPDF_VERS}
ENV PATH=${LHAPATH}/bin:${PATH}
ENV LD_LIBRARY_PATH=${LHAPATH}/lib:${LD_LIBRARY_PATH}
ENV LHAPDF_INC=${LHAPATH}/include
ENV LHAPDF_LIB=${LHAPATH}/lib

WORKDIR /opt/
RUN git clone https://github.com/luketpickering/Generator.git Generator-src
WORKDIR /opt/Generator-src
RUN git checkout R-3_00_06_patched
WORKDIR /opt/
RUN git clone https://github.com/GENIE-MC/Reweight.git Reweight-src
WORKDIR /opt/Reweight-src
RUN git checkout R-1_00_06

ENV GENIE="/opt/Generator-src"
ENV GENIE_VERSION=3_00_06

WORKDIR /opt/Generator-src
RUN mkdir -p /opt/genie/${GENIE_VERSION} \
 && ./configure --prefix=/opt/genie/${GENIE_VERSION} --enable-rwght \
 && make \
 && make install

ENV GENIE_REWEIGHT=/opt/Reweight-src/
WORKDIR /opt/Reweight-src
RUN make && make install

RUN cp /opt/Generator-src/data/evgen/pdfs/GRV98lo_patched.LHgrid \
    ${LHAPATH}/GRV98lo_patched.LHgrid

ENV GENIE="/opt/genie/${GENIE_VERSION}"
ENV GENIE_REWEIGHT=${GENIE}

# Install some things that the GENIE isntall script forget.
RUN cp /opt/Generator-src/VERSION ${GENIE}/
RUN cp -r /opt/Generator-src/config ${GENIE}/
RUN mkdir -p ${GENIE}/data/
RUN cp -r /opt/Generator-src/data/evgen ${GENIE}/data/

RUN mkdir -p ${GENIE}/src/make/
RUN cp /opt/Generator-src/src/make/Make.config_no_paths \
                      ${GENIE}/src/make/

WORKDIR ${GENIE}/src
RUN ln -s -t . ../include/GENIE/*/

WORKDIR /
ENV GENIE_XSEC_DIR=/opt/genie/${GENIE_VERSION}/var/genie/xsec/${GENIE_XSEC_TUNE}-k250-e1000-resfix
RUN mkdir -p ${GENIE_XSEC_DIR}
RUN cp gxspl-min.xml.gz ${GENIE_XSEC_DIR}

ENV GENIE_PHYOPT_DIR=/opt/genie/${GENIE_VERSION}/var/genie/phyopt/dkcharmtau-resfix
RUN mkdir -p ${GENIE_PHYOPT_DIR}
RUN cp -r dkcharmtau-resfix/* ${GENIE_PHYOPT_DIR}/

FROM picker24/buildbox:debian_bullseye-slim

COPY --from=genie_build /opt/pythia/ /opt/pythia/
ENV PYTHIA6=/opt/pythia/6.4.28
ENV LD_LIBRARY_PATH=${PYTHIA6}:${LD_LIBRARY_PATH}

COPY --from=genie_build /opt/root/v6-24-06/ /opt/root/v6-24-06/
ENV ROOTSYS=/opt/root/v6-24-06
ENV PATH=${ROOTSYS}/bin:${PATH}
ENV LD_LIBRARY_PATH=${ROOTSYS}/lib:${LD_LIBRARY_PATH}

COPY --from=genie_build /opt/lhapdf /opt/lhapdf
ENV LHAPDF_VERS=5.9.1
ENV LHAPATH=/opt/lhapdf/${LHAPDF_VERS}
ENV PATH=${LHAPATH}/bin:${PATH}
ENV LD_LIBRARY_PATH=${LHAPATH}/lib:${LD_LIBRARY_PATH}
ENV LHAPDF_INC=${LHAPATH}/include
ENV LHAPDF_LIB=${LHAPATH}/lib

COPY --from=genie_build /opt/genie /opt/genie
ENV GENIE_VERSION=3_00_06
ENV GENIE="/opt/genie/${GENIE_VERSION}"
ENV GENIE_REWEIGHT=${GENIE}

ENV PATH=${GENIE}/bin:${PATH}
ENV LD_LIBRARY_PATH=${GENIE}/lib:${LD_LIBRARY_PATH}
ENV ROOT_INCLUDE_PATH=${GENIE}/include/GENIE:${ROOT_INCLUDE_PATH}

ENV GENIE_XSEC_TUNE=N18_10j_02_11a
ENV GENIE_XSEC_DIR=/opt/genie/${GENIE_VERSION}/var/genie/xsec/${GENIE_XSEC_TUNE}-k250-e1000-resfix
ENV GENIE_XSEC_FILE="${GENIE_XSEC_DIR}/gxspl-min.xml.gz"

ENV GENIE_PHYOPT_DIR=/opt/genie/${GENIE_VERSION}/var/genie/phyopt/dkcharmtau-resfix

ENV GXMLPATH=${GENIE_PHYOPT_DIR}:${GENIE_XSEC_DIR}
