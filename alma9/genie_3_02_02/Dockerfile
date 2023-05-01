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
    && make install -j 5

FROM picker24/root_v6_26_10:alma9 AS genie_build
WORKDIR /

ENV GENIE_XSEC_TUNE_COMPRESSED=G1802a00000
ENV GENIE_XSEC_TUNE=G18_02a_00_000
ENV GENIE_VERSION_DOT=3.02.00
ENV GENIE_SCISOFT_VERSION=3_02_00

RUN wget https://scisoft.fnal.gov/scisoft/packages/genie_xsec/v${GENIE_SCISOFT_VERSION}/genie_xsec-${GENIE_VERSION_DOT}-noarch-${GENIE_XSEC_TUNE_COMPRESSED}-k250-e1000.tar.bz2 \
          -O genie_xsec-${GENIE_VERSION_DOT}-noarch-${GENIE_XSEC_TUNE_COMPRESSED}-k250-e1000.tar.bz2
RUN tar xvf genie_xsec-${GENIE_VERSION_DOT}-noarch-${GENIE_XSEC_TUNE_COMPRESSED}-k250-e1000.tar.bz2
RUN mv genie_xsec/v${GENIE_SCISOFT_VERSION}/NULL/${GENIE_XSEC_TUNE_COMPRESSED}-k250-e1000/data/gxspl-NUsmall.xml ./
COPY gxspl.min.awk /
RUN awk -f gxspl.min.awk gxspl-NUsmall.xml > gxspl-min.xml
RUN gzip gxspl-min.xml

RUN wget https://scisoft.fnal.gov/scisoft/packages/genie_phyopt/v${GENIE_SCISOFT_VERSION}/genie_phyopt-${GENIE_VERSION_DOT}-noarch-dkcharmtau.tar.bz2 \
    -O genie_phyopt-${GENIE_VERSION_DOT}-noarch-dkcharmtau.tar.bz2
RUN tar xvf genie_phyopt-${GENIE_VERSION_DOT}-noarch-dkcharmtau.tar.bz2
RUN cp -r genie_phyopt/v${GENIE_SCISOFT_VERSION}/NULL/dkcharmtau .
RUN rm -r genie_phyopt dkcharmtau/ups

COPY --from=lhapdf_build /opt/lhapdf/ /opt/lhapdf/
ENV LHAPDF_VERS=5.9.1
ENV LHAPATH=/opt/lhapdf/${LHAPDF_VERS}
ENV PATH=${LHAPATH}/bin:${PATH}
ENV LD_LIBRARY_PATH=${LHAPATH}/lib:${LD_LIBRARY_PATH}
ENV LHAPDF_INC=${LHAPATH}/include
ENV LHAPDF_LIB=${LHAPATH}/lib

ENV GENIE_VERSION=3_02_02
ENV GENIE_REWEIGHT_VERSION=1_02_02

WORKDIR /opt/
RUN git clone https://github.com/GENIE-MC/Generator.git Generator-src
WORKDIR /opt/Generator-src
RUN git checkout R-${GENIE_VERSION}
WORKDIR /opt/
RUN git clone https://github.com/luketpickering/Reweight.git Reweight-src
WORKDIR /opt/Reweight-src
# RUN git checkout R-${GENIE_REWEIGHT_VERSION}

ENV GENIE="/opt/Generator-src"

WORKDIR /opt/Generator-src
RUN dnf install -y libnsl2-devel
RUN mkdir -p /opt/genie/${GENIE_VERSION} \
 && ./configure --prefix=/opt/genie/${GENIE_VERSION} \
 && make -j 5 \
 && make install

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

WORKDIR /
ENV GENIE_XSEC_DIR=/opt/genie/${GENIE_VERSION}/var/genie/xsec/${GENIE_XSEC_TUNE}-k250-e1000
RUN mkdir -p ${GENIE_XSEC_DIR}
RUN cp gxspl-min.xml.gz ${GENIE_XSEC_DIR}

ENV GENIE_PHYOPT_DIR=/opt/genie/${GENIE_VERSION}/var/genie/phyopt/dkcharmtau
RUN mkdir -p ${GENIE_PHYOPT_DIR}
RUN cp -r dkcharmtau/* ${GENIE_PHYOPT_DIR}/

FROM picker24/root_v6_26_10:alma9

RUN dnf install -y libnsl2-devel

COPY --from=lhapdf_build /opt/lhapdf /opt/lhapdf
ENV LHAPDF_VERS=5.9.1
ENV LHAPATH=/opt/lhapdf/${LHAPDF_VERS}
ENV PATH=${LHAPATH}/bin:${PATH}
ENV LD_LIBRARY_PATH=${LHAPATH}/lib:${LD_LIBRARY_PATH}
ENV LHAPDF_INC=${LHAPATH}/include
ENV LHAPDF_LIB=${LHAPATH}/lib

COPY --from=genie_build /opt/genie /opt/genie
ENV GENIE_VERSION=3_02_02
ENV GENIE_REWEIGHT_VERSION=1_02_02
ENV GENIE="/opt/genie/${GENIE_VERSION}"
ENV GENIE_REWEIGHT=${GENIE}

ENV PATH=${GENIE}/bin:${PATH}
ENV LD_LIBRARY_PATH=${GENIE}/lib:${LD_LIBRARY_PATH}
ENV ROOT_INCLUDE_PATH=${GENIE}/include/GENIE:${ROOT_INCLUDE_PATH}

ENV GENIE_XSEC_TUNE=G18_02a_00_000
ENV GENIE_XSEC_DIR=/opt/genie/${GENIE_VERSION}/var/genie/xsec/${GENIE_XSEC_TUNE}-k250-e1000
ENV GENIE_XSEC_FILE="${GENIE_XSEC_DIR}/gxspl-min.xml.gz"

ENV GENIE_PHYOPT_DIR=/opt/genie/${GENIE_VERSION}/var/genie/phyopt/dkcharmtau

ENV GXMLPATH=${GENIE_PHYOPT_DIR}:${GENIE_XSEC_DIR}
