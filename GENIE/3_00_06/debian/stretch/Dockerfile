FROM localhost/picker24/root_6_12_6_min:debian_stretch

ARG N_CORE=8

ARG TRANSIENT_SW="build-essential gfortran git python wget libxml2-dev libgsl-dev liblog4cpp5-dev"

RUN apt update && apt install --no-install-recommends -y ${TRANSIENT_SW}

RUN mkdir /opt/lhapdf-src
WORKDIR /opt/lhapdf-src
RUN wget --no-check-certificate \
  https://lhapdf.hepforge.org/downloads/?f=lhapdf-5.9.1.tar.gz \
  -O lhapdf-5.9.1.tar.gz
RUN tar -zxvf lhapdf-5.9.1.tar.gz
RUN mkdir /opt/lhapdf-build
WORKDIR /opt/lhapdf-build/
RUN /opt/lhapdf-src/lhapdf-5.9.1/configure \
            --prefix=/opt/lhapdf/5.9.1 --disable-old-ccwrap --disable-pyext
RUN make install -j ${N_CORE}

RUN rm -r /opt/lhapdf-build /opt/lhapdf-src

ENV LHAPATH "/opt/lhapdf/5.9.1"
ENV LHAPDF_INC "${LHAPATH}/include"
ENV LHAPDF_LIB "${LHAPATH}/lib"
ENV PATH "${LHAPATH}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${LHAPDF_LIB}:${LD_LIBRARY_PATH}"

ENV GENIE "/opt/GENIE-src/Generator"

RUN mkdir /opt/GENIE-src
WORKDIR /opt/GENIE-src
RUN git clone -c http.sslVerify=false \
              https://github.com/GENIE-MC/Generator.git
WORKDIR /opt/GENIE-src/Generator
RUN git checkout R-3_00_06
RUN ./configure --prefix=/opt/GENIE/3_00_06
RUN make -j ${N_CORE}
RUN mkdir -p /opt/GENIE/3_00_06
RUN make install

WORKDIR /opt/GENIE-src

ENV GENIE_REWEIGHT "/opt/GENIE-src/Reweight"

RUN git clone -c http.sslVerify=false \
              https://github.com/GENIE-MC/Reweight.git
WORKDIR /opt/GENIE-src/Reweight
RUN git checkout R-1_00_06
RUN make -j ${N_CORE}
RUN make install

RUN cp /opt/GENIE-src/Generator/data/evgen/pdfs/GRV98lo_patched.LHgrid \
       ${LHAPATH}/GRV98lo_patched.LHgrid

ENV GENIE "/opt/GENIE/3_00_06"
ENV GENIE_REWEIGHT "${GENIE}"

RUN cp -r /opt/GENIE-src/Generator/config ${GENIE}/

#copy in a config file that genie-config expects
RUN mkdir -p ${GENIE}/src/make/
RUN cp /opt/GENIE-src/Generator/src/make/Make.config_no_paths ${GENIE}/src/make/
#make symlinks for things that include ${GENIE}/src
WORKDIR ${GENIE}/src
RUN for i in ${GENIE}/include/GENIE/*; do ln -s ${i}; done

ENV PATH "${GENIE}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${GENIE}/lib:${PYTHIA6}:${LD_LIBRARY_PATH}"
ENV ROOT_INCLUDE_PATH "${GENIE}/include/GENIE:${ROOT_INCLUDE_PATH}"

RUN rm -r /opt/GENIE-src

# #Get rid of everything we don't need
RUN apt remove -y ${TRANSIENT_SW}
RUN apt install --no-install-recommends -y libstdc++6 libgfortran3 libgsl2 liblog4cpp5v5 libxml2
RUN apt autoremove -y --purge && apt clean

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
