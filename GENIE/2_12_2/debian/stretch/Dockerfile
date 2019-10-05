FROM picker24/root_6_12_6_min:latest AS ROOT

FROM picker24/lhapdf_5_9_1:latest AS LHAPDF

FROM picker24/buildbox:latest AS BUILD

# Pull down and trim the splines
RUN mkdir -p /opt/genie-splines
WORKDIR /opt/genie-splines
ADD genie_xsec-2.12.0-noarch-DefaultPlusMECWithNC.tar.bz2 /opt/genie-splines/

WORKDIR /opt/genie-splines/genie_xsec/v2_12_0/NULL/DefaultPlusMECWithNC/data
ADD t2k-nova.gxspl.min.awk /opt/genie-splines/genie_xsec/v2_12_0/NULL/DefaultPlusMECWithNC/data/

RUN awk -f t2k-nova.gxspl.min.awk gxspl-FNALsmall.xml > gxspl-t2k-nova.xml
RUN gzip gxspl-t2k-nova.xml

RUN mkdir -p /var/genie/xsec/DefaultPlusMECWithNC
RUN mv UserPhysicsOptions.xml \
       EventGeneratorListAssembler.xml \
       gxspl-t2k-nova.xml.gz \
    /var/genie/xsec/DefaultPlusMECWithNC/

# Pull in dependencies

COPY --from=ROOT /opt/pythia6 /opt/pythia6

ENV PYTHIA6 "/opt/pythia6/6.4.28"
ENV LD_LIBRARY_PATH "${PYTHIA6}:${LD_LIBRARY_PATH}"

COPY --from=ROOT /opt/root /opt/root

ENV LD_LIBRARY_PATH "/opt/root/v6-12-06/lib:${LD_LIBRARY_PATH}"
ENV LIBPATH /opt/root/v6-12-06/lib
ENV JUPYTER_PATH /opt/root/v6-12-06/etc/notebook
ENV PATH "/opt/root/v6-12-06/bin:/opt/root/v6-12-06/sbin:${PATH}"
ENV DYLD_LIBRARY_PATH /opt/root/v6-12-06/lib
ENV PYTHONPATH /opt/root/v6-12-06/lib
ENV SHLIB_PATH /opt/root/v6-12-06/lib
ENV CMAKE_PREFIX_PATH /opt/root/v6-12-06
ENV ROOTSYS /opt/root/v6-12-06

COPY --from=LHAPDF /opt/lhapdf /opt/lhapdf

ENV LHAPATH "/opt/lhapdf/5.9.1"
ENV LHAPDF_INC "${LHAPATH}/include"
ENV LHAPDF_LIB "${LHAPATH}/lib"
ENV PATH "${LHAPATH}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${LHAPDF_LIB}:${LD_LIBRARY_PATH}"

ENV GENIE "/opt/GENIE-src/Generator"

# build
RUN mkdir /opt/GENIE-src
WORKDIR /opt/GENIE-src
RUN git clone -c http.sslVerify=false \
              https://github.com/GENIE-MC/Generator.git
WORKDIR /opt/GENIE-src/Generator
RUN git checkout R-2_12_2
RUN ./configure --prefix=/opt/genie/2_12_2 --enable-rwght
RUN make 
RUN mkdir -p /opt/genie/2_12_2
RUN make install

RUN cp /opt/GENIE-src/Generator/data/evgen/pdfs/GRV98lo_patched.LHgrid \
       ${LHAPATH}/GRV98lo_patched.LHgrid

ENV GENIE "/opt/genie/2_12_2"

#GENIE install doesn't fancy installing this header, lets help
RUN cp -r /opt/GENIE-src/Generator/src/Interfaces \
          ${GENIE}/include/GENIE/
RUN cp /opt/GENIE-src/Generator/VERSION ${GENIE}/

RUN cp -r /opt/GENIE-src/Generator/config ${GENIE}/
RUN mkdir -p ${GENIE}/data/
RUN cp -r /opt/GENIE-src/Generator/data/evgen ${GENIE}/data/

#copy in a config file that genie-config expects
RUN mkdir -p ${GENIE}/src/make/
RUN cp /opt/GENIE-src/Generator/src/make/Make.config_no_paths ${GENIE}/src/make/
#make symlinks for things that include ${GENIE}/src
WORKDIR ${GENIE}/src
RUN for i in ${GENIE}/include/GENIE/*; do ln -s ${i}; done

FROM picker24/runbox:latest

COPY --from=ROOT /opt/pythia6 /opt/pythia6

ENV PYTHIA6 "/opt/pythia6/6.4.28"
ENV LD_LIBRARY_PATH "${PYTHIA6}:${LD_LIBRARY_PATH}"

COPY --from=ROOT /opt/root /opt/root

ENV LD_LIBRARY_PATH "/opt/root/v6-12-06/lib:${LD_LIBRARY_PATH}"
ENV LIBPATH /opt/root/v6-12-06/lib
ENV JUPYTER_PATH /opt/root/v6-12-06/etc/notebook
ENV PATH "/opt/root/v6-12-06/bin:/opt/root/v6-12-06/sbin:${PATH}"
ENV DYLD_LIBRARY_PATH /opt/root/v6-12-06/lib
ENV PYTHONPATH /opt/root/v6-12-06/lib
ENV SHLIB_PATH /opt/root/v6-12-06/lib
ENV CMAKE_PREFIX_PATH /opt/root/v6-12-06
ENV ROOTSYS /opt/root/v6-12-06

COPY --from=LHAPDF /opt/lhapdf /opt/lhapdf

ENV LHAPATH "/opt/lhapdf/5.9.1"
ENV LHAPDF_INC "${LHAPATH}/include"
ENV LHAPDF_LIB "${LHAPATH}/lib"
ENV PATH "${LHAPATH}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${LHAPDF_LIB}:${LD_LIBRARY_PATH}"

COPY --from=BUILD /opt/genie /opt/genie
COPY --from=BUILD /var/genie /var/genie

ENV GENIE "/opt/genie/2_12_2"
ENV PATH "${GENIE}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${GENIE}/lib:${LD_LIBRARY_PATH}"
ENV ROOT_INCLUDE_PATH "${GENIE}/include/GENIE:${ROOT_INCLUDE_PATH}"

ENV GENIE_XSEC_DIR "/var/genie/xsec/DefaultPlusMECWithNC"
ENV GENIE_XSEC_FILE "${GENIE_XSEC_DIR}/gxspl-t2k-nova.xml.gz"
ENV GXMLPATH "${GENIE_XSEC_DIR}:${GXMLPATH}"

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
