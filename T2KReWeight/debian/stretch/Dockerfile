FROM picker24/neut533:latest AS NEUT

FROM picker24/buildbox:latest AS BUILD

COPY --from=NEUT /opt/cernlib /opt/cernlib

ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT "${CERN}/${CERN_LEVEL}"
ENV PATH "${CERN_ROOT}/bin:${PATH}"

COPY --from=NEUT /opt/root /opt/root

ENV LD_LIBRARY_PATH "/opt/root/v6-12-06/lib:${LD_LIBRARY_PATH}"
ENV LIBPATH /opt/root/v6-12-06/lib
ENV JUPYTER_PATH /opt/root/v6-12-06/etc/notebook
ENV PATH "/opt/root/v6-12-06/bin:/opt/root/v6-12-06/sbin:${PATH}"
ENV DYLD_LIBRARY_PATH /opt/root/v6-12-06/lib
ENV PYTHONPATH /opt/root/v6-12-06/lib
ENV SHLIB_PATH /opt/root/v6-12-06/lib
ENV CMAKE_PREFIX_PATH /opt/root/v6-12-06
ENV ROOTSYS /opt/root/v6-12-06

COPY --from=NEUT /opt/neut /opt/neut

ENV NEUT_ROOT "/opt/neut/5.3.3"
ENV PATH "${NEUT_ROOT}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${NEUT_ROOT}/src/reweight:${NEUT_ROOT}/src/neutclass:${LD_LIBRARY_PATH}"
ENV NEUT_CRSDAT "${NEUT_ROOT}/share/crsdat"
ENV NEUT_CARDS "${NEUT_ROOT}/share/Cards"
ENV ROOT_INCLUDE_PATH "${NEUT_ROOT}/include:${NEUT_ROOT}/src/neutclass:${NEUT_ROOT}/src/reweight:${ROOT_INCLUDE_PATH}"

# NIWGReWeight
## NIWGReWeight src is not freely available, must take a copy of a local repository
ADD NIWGReWeight /opt/NIWGReWeight-src
WORKDIR /opt/NIWGReWeight-src
RUN make

RUN mkdir -p /opt/NIWGReWeight/v1r23p2
RUN cp /opt/NIWGReWeight-src/libNIWGReWeight.so /opt/NIWGReWeight/v1r23p2/
RUN cp /opt/NIWGReWeight-src/*.h /opt/NIWGReWeight/v1r23p2/
RUN cp -r /opt/NIWGReWeight-src/inputs /opt/NIWGReWeight/v1r23p2/

ENV NIWG "/opt/NIWGReWeight/v1r23p2"

# T2KReWeight
## T2KReWeight src is not freely available, must take a copy of a local repository
ADD T2KReWeight /opt/T2KReWeight-src
WORKDIR /opt/T2KReWeight-src

ENV T2KREWEIGHT "/opt/T2KReWeight-src"

RUN ./configure \
      --enable-neut \
          --with-cern=${CERN}/${CERN_LEVEL} \
      --enable-niwg 
RUN ENV_CXXFLAGS=" $(root-config --cflags) " make autogen-headers
RUN ENV_CXXFLAGS=" $(root-config --cflags) " make make-bin-lib-dir
RUN ENV_CXXFLAGS=" $(root-config --cflags) " make src

RUN mkdir -p /opt/T2KReWeight/v1r27p3/bin /opt/T2KReWeight/v1r27p3/lib /opt/T2KReWeight/v1r27p3/include
RUN cp /opt/T2KReWeight-src/src/*.h /opt/T2KReWeight/v1r27p3/include/
RUN cp /opt/T2KReWeight-src/lib/libT2KReWeight.so /opt/T2KReWeight/v1r27p3/lib/
RUN cp /opt/T2KReWeight-src/app/genWeightsFromNeutroot_example /opt/T2KReWeight/v1r27p3/bin/

ENV T2KREWEIGHT "/opt/T2KReWeight/v1r27p3"

#Things often include T2KReWeight
RUN ln -s ${T2KREWEIGHT}/include ${T2KREWEIGHT}/src

FROM picker24/runbox:latest

COPY --from=NEUT /opt/cernlib /opt/cernlib

ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT "${CERN}/${CERN_LEVEL}"
ENV PATH "${CERN_ROOT}/bin:${PATH}"

COPY --from=NEUT /opt/root /opt/root

ENV LD_LIBRARY_PATH "/opt/root/v6-12-06/lib:${LD_LIBRARY_PATH}"
ENV LIBPATH /opt/root/v6-12-06/lib
ENV JUPYTER_PATH /opt/root/v6-12-06/etc/notebook
ENV PATH "/opt/root/v6-12-06/bin:/opt/root/v6-12-06/sbin:${PATH}"
ENV DYLD_LIBRARY_PATH /opt/root/v6-12-06/lib
ENV PYTHONPATH /opt/root/v6-12-06/lib
ENV SHLIB_PATH /opt/root/v6-12-06/lib
ENV CMAKE_PREFIX_PATH /opt/root/v6-12-06
ENV ROOTSYS /opt/root/v6-12-06

COPY --from=NEUT /opt/neut /opt/neut

ENV NEUT_ROOT "/opt/neut/5.3.3"
ENV PATH "${NEUT_ROOT}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${NEUT_ROOT}/src/reweight:${NEUT_ROOT}/src/neutclass:${LD_LIBRARY_PATH}"
ENV NEUT_CRSDAT "${NEUT_ROOT}/share/crsdat"
ENV NEUT_CARDS "${NEUT_ROOT}/share/Cards"
ENV ROOT_INCLUDE_PATH "${NEUT_ROOT}/include:${NEUT_ROOT}/src/neutclass:${NEUT_ROOT}/src/reweight:${ROOT_INCLUDE_PATH}"

COPY --from=BUILD /opt/NIWGReWeight /opt/NIWGReWeight

ENV NIWG "/opt/NIWGReWeight/v1r23p2"
ENV LD_LIBRARY_PATH "${NIWG}:${LD_LIBRARY_PATH}"

COPY --from=BUILD /opt/T2KReWeight /opt/T2KReWeight

ENV T2KREWEIGHT "/opt/T2KReWeight/v1r27p3"
ENV LD_LIBRARY_PATH "${T2KREWEIGHT}/lib:${LD_LIBRARY_PATH}"

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
