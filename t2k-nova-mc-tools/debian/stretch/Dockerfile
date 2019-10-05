FROM picker24/novarwgt_v00.23:latest AS NOVARWGT

FROM picker24/t2kreweight_v1r27p3:latest AS T2KREWEIGHT

FROM picker24/buildbox:latest AS BUILD

COPY --from=NOVARWGT /opt/pythia6 /opt/pythia6

ENV PYTHIA6 "/opt/pythia6/6.4.28"
ENV LD_LIBRARY_PATH "${PYTHIA6}/lib:${LD_LIBRARY_PATH}"

COPY --from=NOVARWGT /opt/root /opt/root

ENV LD_LIBRARY_PATH "/opt/root/v6-12-06/lib:${LD_LIBRARY_PATH}"
ENV LIBPATH /opt/root/v6-12-06/lib
ENV JUPYTER_PATH /opt/root/v6-12-06/etc/notebook
ENV PATH "/opt/root/v6-12-06/bin:/opt/root/v6-12-06/sbin:${PATH}"
ENV DYLD_LIBRARY_PATH /opt/root/v6-12-06/lib
ENV PYTHONPATH /opt/root/v6-12-06/lib
ENV SHLIB_PATH /opt/root/v6-12-06/lib
ENV CMAKE_PREFIX_PATH /opt/root/v6-12-06
ENV ROOTSYS /opt/root/v6-12-06

COPY --from=NOVARWGT /opt/lhapdf /opt/lhapdf

ENV LHAPATH "/opt/lhapdf/5.9.1"
ENV LHAPDF_INC "${LHAPATH}/include"
ENV LHAPDF_LIB "${LHAPATH}/lib"
ENV PATH "${LHAPATH}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${LHAPDF_LIB}:${LD_LIBRARY_PATH}"

COPY --from=NOVARWGT /opt/genie /opt/genie
COPY --from=NOVARWGT /var/genie /var/genie

ENV GENIE "/opt/genie/2_12_2"
ENV PATH "${GENIE}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${GENIE}/lib:${LD_LIBRARY_PATH}"
ENV ROOT_INCLUDE_PATH "${GENIE}/include/GENIE:${ROOT_INCLUDE_PATH}"

ENV GENIE_XSEC_DIR "/var/genie/xsec/DefaultPlusMECWithNC"
ENV GENIE_XSEC_FILE "${GENIE_XSEC_DIR}/gxspl-t2k-nova.xml.gz"
ENV GXMLPATH "${GENIE_XSEC_DIR}:${GXMLPATH}"

ENV PYTHIA6_LIBRARY ${PYTHIA6}

COPY --from=NOVARWGT /opt/NOvARwgt /opt/NOvARwgt

ENV NOVARWGT "/opt/NOvARwgt/v00.23"
ENV LD_LIBRARY_PATH "${NOVARWGT}/lib:${LD_LIBRARY_PATH}"

COPY --from=T2KREWEIGHT /opt/cernlib /opt/cernlib

ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT "${CERN}/${CERN_LEVEL}"
ENV PATH "${CERN_ROOT}/bin:${PATH}"

COPY --from=T2KREWEIGHT /opt/neut /opt/neut

ENV NEUT_ROOT "/opt/neut/5.3.3"
ENV PATH "${NEUT_ROOT}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${NEUT_ROOT}/src/reweight:${NEUT_ROOT}/src/neutclass:${LD_LIBRARY_PATH}"
ENV NEUT_CRSDAT "${NEUT_ROOT}/share/crsdat"
ENV NEUT_CARDS "${NEUT_ROOT}/share/Cards"
ENV ROOT_INCLUDE_PATH "${NEUT_ROOT}/include:${NEUT_ROOT}/src/neutclass:${NEUT_ROOT}/src/reweight:${ROOT_INCLUDE_PATH}"

COPY --from=T2KREWEIGHT /opt/NIWGReWeight /opt/NIWGReWeight

ENV NIWG "/opt/NIWGReWeight/v1r23p2"
ENV LD_LIBRARY_PATH "${NIWG}:${LD_LIBRARY_PATH}"

COPY --from=T2KREWEIGHT /opt/T2KReWeight /opt/T2KReWeight

ENV T2KREWEIGHT "/opt/T2KReWeight/v1r27p3"
ENV LD_LIBRARY_PATH "${T2KREWEIGHT}/lib:${LD_LIBRARY_PATH}"

#Start NUISANCE build
RUN mkdir -p /opt/nuisance-src
WORKDIR /opt/nuisance-src
RUN git clone -c http.sslVerify=false \
              https://github.com/NUISANCEMC/nuisance.git
WORKDIR /opt/nuisance-src/nuisance

RUN mkdir /opt/nuisance-build
WORKDIR /opt/nuisance-build
RUN cmake /opt/nuisance-src/nuisance -DCMAKE_INSTALL_PREFIX=/opt/nuisance \
          -DUSE_GENIE=1 -DUSE_NEUT=1 -DUSE_T2K=1 -DUSE_NIWG=1 \
          -DCMAKE_CXX_STANDARD=14 \
          -DUSE_NOvARwgt=1 -DCMAKE_BUILD_TYPE=RELEASE
RUN make -j ${N_CORE}
RUN make install
#NUISANCE install process could use some love
RUN cp -r /opt/nuisance-src/nuisance/data \
          /opt/nuisance-src/nuisance/parameters \
          /opt/nuisance/

FROM picker24/runbox:latest 

COPY --from=NOVARWGT /opt/pythia6 /opt/pythia6

ENV PYTHIA6 "/opt/pythia6/6.4.28"
ENV LD_LIBRARY_PATH "${PYTHIA6}/lib:${LD_LIBRARY_PATH}"

COPY --from=NOVARWGT /opt/root /opt/root

ENV LD_LIBRARY_PATH "/opt/root/v6-12-06/lib:${LD_LIBRARY_PATH}"
ENV LIBPATH /opt/root/v6-12-06/lib
ENV JUPYTER_PATH /opt/root/v6-12-06/etc/notebook
ENV PATH "/opt/root/v6-12-06/bin:/opt/root/v6-12-06/sbin:${PATH}"
ENV DYLD_LIBRARY_PATH /opt/root/v6-12-06/lib
ENV PYTHONPATH /opt/root/v6-12-06/lib
ENV SHLIB_PATH /opt/root/v6-12-06/lib
ENV CMAKE_PREFIX_PATH /opt/root/v6-12-06
ENV ROOTSYS /opt/root/v6-12-06

COPY --from=NOVARWGT /opt/lhapdf /opt/lhapdf

ENV LHAPATH "/opt/lhapdf/5.9.1"
ENV LHAPDF_INC "${LHAPATH}/include"
ENV LHAPDF_LIB "${LHAPATH}/lib"
ENV PATH "${LHAPATH}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${LHAPDF_LIB}:${LD_LIBRARY_PATH}"

COPY --from=NOVARWGT /opt/genie /opt/genie
COPY --from=NOVARWGT /var/genie /var/genie

ENV GENIE "/opt/genie/2_12_2"
ENV PATH "${GENIE}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${GENIE}/lib:${LD_LIBRARY_PATH}"
ENV ROOT_INCLUDE_PATH "${GENIE}/include/GENIE:${ROOT_INCLUDE_PATH}"

ENV GENIE_XSEC_DIR "/var/genie/xsec/DefaultPlusMECWithNC"
ENV GENIE_XSEC_FILE "${GENIE_XSEC_DIR}/gxspl-t2k-nova.xml.gz"
ENV GXMLPATH "${GENIE_XSEC_DIR}:${GXMLPATH}"

ENV PYTHIA6_LIBRARY ${PYTHIA6}

COPY --from=NOVARWGT /opt/NOvARwgt /opt/NOvARwgt

ENV NOVARWGT "/opt/NOvARwgt/v00.23"
ENV LD_LIBRARY_PATH "${NOVARWGT}/lib:${LD_LIBRARY_PATH}"

COPY --from=T2KREWEIGHT /opt/cernlib /opt/cernlib

ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT "${CERN}/${CERN_LEVEL}"
ENV PATH "${CERN_ROOT}/bin:${PATH}"

COPY --from=T2KREWEIGHT /opt/neut /opt/neut

ENV NEUT_ROOT "/opt/neut/5.3.3"
ENV PATH "${NEUT_ROOT}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${NEUT_ROOT}/src/reweight:${NEUT_ROOT}/src/neutclass:${LD_LIBRARY_PATH}"
ENV NEUT_CRSDAT "${NEUT_ROOT}/share/crsdat"
ENV NEUT_CARDS "${NEUT_ROOT}/share/Cards"
ENV ROOT_INCLUDE_PATH "${NEUT_ROOT}/include:${NEUT_ROOT}/src/neutclass:${NEUT_ROOT}/src/reweight:${ROOT_INCLUDE_PATH}"

COPY --from=T2KREWEIGHT /opt/NIWGReWeight /opt/NIWGReWeight

ENV NIWG "/opt/NIWGReWeight/v1r23p2"
ENV LD_LIBRARY_PATH "${NIWG}:${LD_LIBRARY_PATH}"

COPY --from=T2KREWEIGHT /opt/T2KReWeight /opt/T2KReWeight

ENV T2KREWEIGHT "/opt/T2KReWeight/v1r27p3"
ENV LD_LIBRARY_PATH "${T2KREWEIGHT}/lib:${LD_LIBRARY_PATH}"

COPY --from=BUILD /opt/nuisance /opt/nuisance

ENV NUISANCE /opt/nuisance
ENV PATH "${NUISANCE}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${NUISANCE}/lib:${LD_LIBRARY_PATH}"

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
