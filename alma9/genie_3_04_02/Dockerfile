# syntax=docker/dockerfile:1
FROM picker24/buildbox:alma9 AS lhapdf_build
WORKDIR /

RUN mkdir -p /opt/LHAPDF-src
WORKDIR /opt/LHAPDF-src

ENV LHAPDF_VERS=6.5.1

RUN wget https://lhapdf.hepforge.org/downloads/LHAPDF-${LHAPDF_VERS}.tar.gz \
         -O LHAPDF-${LHAPDF_VERS}.tar.gz \
    && tar -zxvf LHAPDF-${LHAPDF_VERS}.tar.gz

WORKDIR /opt/LHAPDF-src/LHAPDF-6.5.1/config/
ADD config.guess config.sub /opt/LHAPDF-src/LHAPDF-6.5.1/config/
RUN chmod +x config.guess config.sub

RUN mkdir -p /opt/LHAPDF-build /opt/LHAPDF/${LHAPDF_VERS}
WORKDIR /opt/LHAPDF-build

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN /opt/LHAPDF-src/LHAPDF-${LHAPDF_VERS}/configure \
                                    --prefix=/opt/LHAPDF/${LHAPDF_VERS} \
    && make install -j 4

FROM picker24/buildbox:alma9 AS genie_build
WORKDIR /

COPY --from=lhapdf_build /opt/LHAPDF/ /opt/LHAPDF/
ENV LHAPDF_VERS=6.5.1
ENV LHAPATH=/opt/LHAPDF/${LHAPDF_VERS}
ENV PATH=${LHAPATH}/bin:${PATH}
ENV LD_LIBRARY_PATH=${LHAPATH}/lib:${LD_LIBRARY_PATH}
ENV LHAPDF_INC=${LHAPATH}/include
ENV LHAPDF_LIB=${LHAPATH}/lib

ENV ROOTSYS=/usr

ENV GENIE_VERSION=3_04_02
ENV GENIE_REWEIGHT_VERSION=1_02_04

WORKDIR /opt/
RUN git clone --depth 1 --branch hotfix/root_search_dehardcode https://github.com/luketpickering/Generator.git Generator-src
RUN git clone --depth 1 --branch R-${GENIE_REWEIGHT_VERSION} https://github.com/GENIE-MC/Reweight.git Reweight-src

ENV GENIE=/opt/Generator-src

WORKDIR /opt/Generator-src
RUN mkdir -p /opt/genie/${GENIE_VERSION} \
 && ./configure --prefix=/opt/genie/${GENIE_VERSION} --enable-debug --enable-lhapdf6 \
 && make -j 4 && make install

ENV GENIE_REWEIGHT=/opt/Reweight-src
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

RUN mv ${GENIE}/config/Messenger_whisper.xml ${GENIE}/config/Messenger.xml
RUN sed -i '$ d' ${GENIE}/config/Messenger.xml
RUN echo '  <priority msgstream="ResonanceDecay">      FATAL </priority>' >> ${GENIE}/config/Messenger.xml
RUN echo '  <priority msgstream="Pythia6Decay">        FATAL </priority>' >> ${GENIE}/config/Messenger.xml
RUN echo '  <priority msgstream="INukeNucleonCorr">    FATAL </priority>' >> ${GENIE}/config/Messenger.xml
RUN echo '  <priority msgstream="gevgen_fnal">         FATAL </priority>' >> ${GENIE}/config/Messenger.xml
RUN echo '</messenger_config>' >> ${GENIE}/config/Messenger.xml

RUN mkdir -p ${GENIE}/src/make/
RUN cp /opt/Generator-src/src/make/Make.config_no_paths \
                      ${GENIE}/src/make/

WORKDIR ${GENIE}/src
RUN ln -s -t . ../include/GENIE/*/

## Final container
FROM picker24/buildbox:alma9

COPY --from=lhapdf_build /opt/LHAPDF /opt/LHAPDF
ENV LHAPDF_VERS=6.5.1 \
    LHAPATH=/opt/LHAPDF/6.5.1 \
    PATH=/opt/LHAPDF/6.5.1/bin:${PATH} \
    LD_LIBRARY_PATH=/opt/LHAPDF/6.5.1/lib:${LD_LIBRARY_PATH} \
    LHAPDF_INC=/opt/LHAPDF/6.5.1/include \
    LHAPDF_LIB=/opt/LHAPDF/6.5.1/lib \
    GENIE_VERSION=3_04_02 \
    GENIE_REWEIGHT_VERSION=1_04_00 \
    GENIE=/opt/genie/3_04_02 \
    GENIE_REWEIGHT=/opt/genie/3_04_02

COPY --from=genie_build /opt/genie /opt/genie

RUN mkdir -p /opt/genie/utils/
ADD  genie_fetch_tune \
     genie_set_tune \
     genie_list_tunes \
     gxspl.min.awk \
  /opt/genie/utils/

RUN /opt/genie/utils/genie_fetch_tune 3_04_00 AR23_20i_00_000 \
    && /opt/genie/utils/genie_fetch_tune 3_04_00 G18_10a_02_11a \
    && /opt/genie/utils/genie_fetch_tune 3_04_00 G21_11a_00_000

ENV PATH=${GENIE}/bin:/opt/genie/utils/:${PATH} \
    LD_LIBRARY_PATH=${GENIE_REWEIGHT}/lib:${GENIE}/lib:${LD_LIBRARY_PATH} \
    ROOT_INCLUDE_PATH=${GENIE}/include/GENIE:${ROOT_INCLUDE_PATH}\
    GENIE_XSEC_VERSION=3_04_00 \
    GENIE_XSEC_TUNE=AR23_20i_00_000 \
    GENIE_XSEC_DIR=/opt/genie_xsec/3_04_00/AR23_20i_00_000 \
    GENIE_XSEC_FILE=/opt/genie_xsec/3_04_00/AR23_20i_00_000/gxspl-min.xml.gz \
    GENIE_PHYOPT_DIR=/opt/genie_phyopt/3_04_00/dkcharmtau \
    GXMLPATH=/opt/genie_phyopt/3_04_00/dkcharmtau:/opt/genie_xsec/3_04_00/AR23_20i_00_000
