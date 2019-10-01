FROM picker24/root_6_12_6:debian_stretch

ARG N_CORE=8

ARG TRANSIENT_SW="build-essential git python wget libgsl-dev liblog4cpp5-dev"

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

RUN rm -rf /opt/lhapdf-build

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
RUN git checkout R-2_12_2
RUN ./configure --prefix=/opt/GENIE/2_12_2 --enable-rwght
RUN make
RUN make install

RUN cp /opt/GENIE-src/Generator/data/evgen/pdfs/GRV98lo_pdflib.LHgrid \
       ${LHAPATH}}/GRV98lo_patched.LHgrid

RUN rm -rf /opt/GENIE-src

ENV GENIE "/opt/GENIE/2_12_2"

# #Get rid of everything we don't need
RUN apt remove -y ${TRANSIENT_SW}
RUN apt install --no-install-recommends -y libstdc++6 libgsl2 liblog4cpp5v5
RUN apt autoremove -y --purge && apt clean

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
