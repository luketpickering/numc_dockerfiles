FROM picker24/cernlib2005:debian_stretch AS CERNLIB

#NEUT image generally based on the ROOT image
FROM picker24/root_6:debian_stretch

# Pull in CERNLIB
COPY --from=CERNLIB /opt/cernlib /opt/

ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT "${CERN}/${CERN_LEVEL}"
ENV PATH "${CERN_ROOT}/bin:${PATH}"

# Start this build

ARG TRANSIENT_SW="build-essential gfortran csh"

RUN apt update && apt install --no-install-recommends -y ${TRANSIENT_SW}

# NEUT
## NEUT src is not freely available, must take a copy of a local repository
RUN mkdir /opt/neut-src
ADD neut_5.3.3_maqefix_t2krw_v1r27p3.tar.gz /opt/neut-src

WORKDIR /opt/neut-src
ENV NEUT_ROOT "/opt/neut-src"
ENV FC "gfortran"
WORKDIR /opt/neut-src/src/neutsmpl
RUN ./Makeneutsmpl.csh
WORKDIR /opt/neut-src/src/reweight
RUN make all

RUN mkdir -p /opt/neut/5.3.3/bin/
RUN cp /opt/neut-src/src/neutsmpl/neutroot2 /opt/neut/5.3.3/bin/
RUN cp -r /opt/neut-src/lib /opt/neut/5.3.3/
RUN mkdir -p /opt/neut/5.3.3/include
RUN cp /opt/neut-src/inc/*.h /opt/neut/5.3.3/include
RUN cp /opt/neut-src/include/*.h /opt/neut/5.3.3/include
RUN mkdir -p /opt/neut/5.3.3/src/neutclass
RUN cp /opt/neut-src/src/neutclass/*.h /opt/neut/5.3.3/src/neutclass
RUN cp /opt/neut-src/src/neutclass/*.so /opt/neut/5.3.3/src/neutclass
RUN mkdir -p /opt/neut/5.3.3/src/reweight
RUN cp /opt/neut-src/src/reweight/*.so /opt/neut/5.3.3/src/reweight
RUN cp /opt/neut-src/src/reweight/*.h /opt/neut/5.3.3/src/reweight
RUN cp /opt/neut-src/src/reweight/*.h /opt/neut/5.3.3/include

RUN mkdir -p /opt/neut/5.3.3/share/
RUN cp -r /opt/neut-src/src/crsdat /opt/neut/5.3.3/share/
RUN cp -r /opt/neut-src/src/neutsmpl/Cards /opt/neut/5.3.3/share/

RUN rm -rf /opt/neut-src

ENV PATH "/opt/neut/5.3.3/bin:${PATH}"
ENV NEUT_ROOT "/opt/neut/5.3.3"
ENV NEUT_CRSDAT "/opt/neut/5.3.3/share/crsdat"
ENV NEUT_CARDS "/opt/neut/5.3.3/share/Cards"

#Get rid of everything we don't need
RUN apt remove -y ${TRANSIENT_SW}
RUN apt install --no-install-recommends -y libstdc++6 libgfortran3
RUN apt autoremove -y --purge && apt clean

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
