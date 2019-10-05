FROM picker24/genie_2_12_2:latest AS GENIE

FROM picker24/buildbox:latest AS BUILD

COPY --from=GENIE /opt/pythia6 /opt/pythia6

ENV PYTHIA6 "/opt/pythia6/6.4.28"
ENV LD_LIBRARY_PATH "${PYTHIA6}/lib:${LD_LIBRARY_PATH}"

COPY --from=GENIE /opt/root /opt/root

ENV LD_LIBRARY_PATH "/opt/root/v6-12-06/lib:${LD_LIBRARY_PATH}"
ENV LIBPATH /opt/root/v6-12-06/lib
ENV JUPYTER_PATH /opt/root/v6-12-06/etc/notebook
ENV PATH "/opt/root/v6-12-06/bin:/opt/root/v6-12-06/sbin:${PATH}"
ENV DYLD_LIBRARY_PATH /opt/root/v6-12-06/lib
ENV PYTHONPATH /opt/root/v6-12-06/lib
ENV SHLIB_PATH /opt/root/v6-12-06/lib
ENV CMAKE_PREFIX_PATH /opt/root/v6-12-06
ENV ROOTSYS /opt/root/v6-12-06

COPY --from=GENIE /opt/lhapdf /opt/lhapdf

ENV LHAPATH "/opt/lhapdf/5.9.1"
ENV LHAPDF_INC "${LHAPATH}/include"
ENV LHAPDF_LIB "${LHAPATH}/lib"
ENV PATH "${LHAPATH}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${LHAPDF_LIB}:${LD_LIBRARY_PATH}"

COPY --from=GENIE /opt/genie /opt/genie
COPY --from=GENIE /var/genie /var/genie

ENV GENIE "/opt/genie/2_12_2"
ENV PATH "${GENIE}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${GENIE}/lib:${LD_LIBRARY_PATH}"
ENV ROOT_INCLUDE_PATH "${GENIE}/include/GENIE:${ROOT_INCLUDE_PATH}"

ENV GENIE_XSEC_DIR "/var/genie/xsec/DefaultPlusMECWithNC"
ENV GENIE_XSEC_FILE "${GENIE_XSEC_DIR}/gxspl-t2k-nova.xml.gz"
ENV GXMLPATH "${GENIE_XSEC_DIR}:${GXMLPATH}"

ENV PYTHIA6_LIBRARY ${PYTHIA6}

# NOvARwgt
## NOvARwgt src is not freely available, must take a copy of a local repository
ADD NOvARwgt /opt/NOvARwgt-src
WORKDIR /opt/NOvARwgt-src/
RUN git checkout v00.23
RUN sed -i "s/cmake_minimum_required(VERSION 3.10)/cmake_minimum_required(VERSION 3.7)/g" CMakeLists.txt

RUN mkdir /opt/NOvARwgt-build
WORKDIR /opt/NOvARwgt-build
RUN cmake /opt/NOvARwgt-src -DCMAKE_INSTALL_PREFIX=/opt/NOvARwgt/v00.23 \
          -DNOVARWGT_USE_NUSIMDATA=OFF -DNOVARWGT_USE_CETLIB=OFF \
          -DNOVARWGT_USE_GENIE=ON -DNOVARWGT_INSTALL_SOURCE=OFF \
          -DCMAKE_BUILD_TYPE=RELEASE
RUN make -j ${N_CORE}
RUN make install

FROM picker24/runbox:latest

COPY --from=GENIE /opt/pythia6 /opt/pythia6

ENV PYTHIA6 "/opt/pythia6/6.4.28"
ENV LD_LIBRARY_PATH "${PYTHIA6}/lib:${LD_LIBRARY_PATH}"

COPY --from=GENIE /opt/root /opt/root

ENV LD_LIBRARY_PATH "/opt/root/v6-12-06/lib:${LD_LIBRARY_PATH}"
ENV LIBPATH /opt/root/v6-12-06/lib
ENV JUPYTER_PATH /opt/root/v6-12-06/etc/notebook
ENV PATH "/opt/root/v6-12-06/bin:/opt/root/v6-12-06/sbin:${PATH}"
ENV DYLD_LIBRARY_PATH /opt/root/v6-12-06/lib
ENV PYTHONPATH /opt/root/v6-12-06/lib
ENV SHLIB_PATH /opt/root/v6-12-06/lib
ENV CMAKE_PREFIX_PATH /opt/root/v6-12-06
ENV ROOTSYS /opt/root/v6-12-06

COPY --from=GENIE /opt/lhapdf /opt/lhapdf

ENV LHAPATH "/opt/lhapdf/5.9.1"
ENV LHAPDF_INC "${LHAPATH}/include"
ENV LHAPDF_LIB "${LHAPATH}/lib"
ENV PATH "${LHAPATH}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${LHAPDF_LIB}:${LD_LIBRARY_PATH}"

COPY --from=GENIE /opt/genie /opt/genie
COPY --from=GENIE /var/genie /var/genie

ENV GENIE "/opt/genie/2_12_2"
ENV PATH "${GENIE}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${GENIE}/lib:${LD_LIBRARY_PATH}"
ENV ROOT_INCLUDE_PATH "${GENIE}/include/GENIE:${ROOT_INCLUDE_PATH}"

ENV GENIE_XSEC_DIR "/var/genie/xsec/DefaultPlusMECWithNC"
ENV GENIE_XSEC_FILE "${GENIE_XSEC_DIR}/gxspl-t2k-nova.xml.gz"
ENV GXMLPATH "${GENIE_XSEC_DIR}:${GXMLPATH}"

ENV PYTHIA6_LIBRARY ${PYTHIA6}

COPY --from=BUILD /opt/NOvARwgt /opt/NOvARwgt

ENV NOVARWGT "/opt/NOvARwgt/v00.23"
ENV LD_LIBRARY_PATH "${NOVARWGT}/lib:${LD_LIBRARY_PATH}"

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
