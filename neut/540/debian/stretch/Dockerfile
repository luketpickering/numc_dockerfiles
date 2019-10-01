FROM picker24/cernlib2005:debian_stretch AS CERNLIB

#NEUT image generally based on the ROOT image
FROM picker24/root_6_12_6:debian_stretch

# Pull in CERNLIB
COPY --from=CERNLIB /opt/cernlib /opt/cernlib

ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT "${CERN}/${CERN_LEVEL}"
ENV PATH "${CERN_ROOT}/bin:${PATH}"

# Start this build

ARG TRANSIENT_SW="build-essential gfortran automake libtool"

RUN apt update && apt install --no-install-recommends -y ${TRANSIENT_SW}

ARG N_CORE=8

# NEUT
## NEUT src is not freely available, must take a copy of a local repository
ADD neut /opt/neut-src
WORKDIR /opt/neut-src
WORKDIR /opt/neut-src/src
RUN autoreconf -i --force
RUN mkdir -p /opt/neut-build /opt/neut
WORKDIR /opt/neut-build
RUN /opt/neut-src/src/configure --prefix=/opt/neut/5.4.0
RUN make -j ${N_CORE}
RUN make install
RUN mkdir -p /opt/neut/share/
RUN cp -r /opt/neut-src/src/crsdat /opt/neut/share/
RUN cp -r /opt/neut-src/src/neutsmpl/Cards /opt/neut/share/
WORKDIR /opt
RUN rm -rf /opt/neut-src /opt/neut-build

ENV PATH "/opt/neut/5.4.0/bin:${PATH}"
ENV NEUT_ROOT "/opt/neut/5.4.0"
ENV NEUT_CRSDAT "/opt/neut/5.4.0/share/crsdat"
ENV NEUT_CARDS "/opt/neut/5.4.0/share/Cards"

#Get rid of everything we don't need
RUN apt remove -y ${TRANSIENT_SW}
RUN apt install --no-install-recommends -y libstdc++6 libgfortran3
RUN apt autoremove -y --purge && apt clean

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
