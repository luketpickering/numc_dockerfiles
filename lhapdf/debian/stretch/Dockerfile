FROM picker24/buildbox:latest AS BUILD

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

FROM picker24/runbox:latest

COPY --from=BUILD /opt/lhapdf /opt/lhapdf

ENV LHAPATH "/opt/lhapdf/5.9.1"
ENV LHAPDF_INC "${LHAPATH}/include"
ENV LHAPDF_LIB "${LHAPATH}/lib"
ENV PATH "${LHAPATH}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${LHAPDF_LIB}:${LD_LIBRARY_PATH}"

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
