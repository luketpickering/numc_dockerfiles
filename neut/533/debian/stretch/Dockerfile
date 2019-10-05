FROM picker24/cernlib2005:debian_stretch AS CERNLIB

FROM picker24/root_6_12_6_min:debian_stretch AS ROOT

COPY --from=CERNLIB /opt/cernlib /opt/cernlib

ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT "${CERN}/${CERN_LEVEL}"
ENV PATH "${CERN_ROOT}/bin:${PATH}"

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

FROM picker24/buildbox:latest AS BUILD

# NEUT
## NEUT src is not freely available, must take a copy of a local repository
RUN mkdir -p /opt/neut/5.3.3
ADD neut_5.3.3_maqefix_t2krw_v1r27p3.tar.gz /opt/neut/5.3.3

WORKDIR /opt/neut/5.3.3
ENV NEUT_ROOT "/opt/neut/5.3.3"
ENV FC "gfortran"
WORKDIR /opt/neut/5.3.3/src/neutsmpl
# Fix no-pie on neutroot2
RUN sed -i "s/neutroot.o -Xlinker/neutroot.o -fno-pie -fno-PIE -no-pie -Xlinker/" GNUmakefile.neutroot
RUN ./Makeneutsmpl.csh
WORKDIR /opt/neut/5.3.3/src/reweight
RUN make all

# building it there adds sensible rpaths... move it out the way and
# throw away the source
WORKDIR /opt/neut/
RUN mv /opt/neut/5.3.3 /opt/neut-src
RUN mkdir -p /opt/neut/5.3.3/bin/
#dummy directory... the rpaths are really stupid
RUN mkdir -p /opt/neut/5.3.3/src/neutsmpl

RUN cp /opt/neut-src/src/neutsmpl/neutroot2 /opt/neut/5.3.3/bin/
RUN cp -r /opt/neut-src/lib /opt/neut/5.3.3/
RUN mkdir -p /opt/neut/5.3.3/include
RUN cp /opt/neut-src/inc/*.h /opt/neut/5.3.3/include
RUN cp /opt/neut-src/include/*.h /opt/neut/5.3.3/include
RUN mkdir -p /opt/neut/5.3.3/src/neutclass
RUN cp /opt/neut-src/src/neutclass/*.h /opt/neut/5.3.3/src/neutclass
RUN cp /opt/neut-src/src/neutclass/*.so /opt/neut/5.3.3/src/neutclass
RUN cp /opt/neut-src/src/neutclass/*.pcm /opt/neut/5.3.3/src/neutclass
RUN mkdir -p /opt/neut/5.3.3/src/reweight
RUN cp /opt/neut-src/src/reweight/*.so /opt/neut/5.3.3/src/reweight
RUN cp /opt/neut-src/src/reweight/*.pcm /opt/neut/5.3.3/src/reweight
RUN cp /opt/neut-src/src/reweight/*.h /opt/neut/5.3.3/src/reweight
RUN cp /opt/neut-src/src/reweight/*.h /opt/neut/5.3.3/include

RUN mkdir -p /opt/neut/5.3.3/share/
RUN cp -r /opt/neut-src/src/crsdat /opt/neut/5.3.3/share/
RUN cp -r /opt/neut-src/src/neutsmpl/Cards /opt/neut/5.3.3/share/

FROM picker24/runbox:latest

COPY --from=CERNLIB /opt/cernlib /opt/cernlib

ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT "${CERN}/${CERN_LEVEL}"
ENV PATH "${CERN_ROOT}/bin:${PATH}"

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

COPY --from=BUILD /opt/neut /opt/neut

ENV NEUT_ROOT "/opt/neut/5.3.3"
ENV PATH "${NEUT_ROOT}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${NEUT_ROOT}/src/reweight:${NEUT_ROOT}/src/neutclass:${LD_LIBRARY_PATH}"
ENV NEUT_CRSDAT "${NEUT_ROOT}/share/crsdat"
ENV NEUT_CARDS "${NEUT_ROOT}/share/Cards"
ENV ROOT_INCLUDE_PATH "${NEUT_ROOT}/include:${NEUT_ROOT}/src/neutclass:${NEUT_ROOT}/src/reweight:${ROOT_INCLUDE_PATH}"

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
