FROM debian:stretch-slim

ARG TRANSIENT_SW="build-essential gfortran git wget xutils-dev libxt-dev libmotif-dev libgmp3-dev csh tcsh ed"

RUN apt update && apt install --no-install-recommends -y ${TRANSIENT_SW}

RUN ln -s /usr/bin/make /usr/bin/gmake

# CERNLIB
RUN mkdir -p /opt/cernlib-src /opt/cernlib
WORKDIR /opt/cernlib-src
RUN git clone -c http.sslVerify=false \
              https://github.com/luketpickering/cernlibgcc5-.git
WORKDIR /opt/cernlib-src/cernlibgcc5-
RUN ./build_cernlib.sh
RUN mkdir -p /opt/cernlib/2005/
RUN mv /opt/cernlib-src/cernlibgcc5-/cernlib_build/2005/bin /opt/cernlib/2005/
RUN mv /opt/cernlib-src/cernlibgcc5-/cernlib_build/2005/include /opt/cernlib/2005/
RUN mv /opt/cernlib-src/cernlibgcc5-/cernlib_build/2005/lib /opt/cernlib/2005/

RUN rm -rf /opt/cernlib-src

ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT "${CERN}/${CERN_LEVEL}"
ENV PATH "${CERN_ROOT}/bin:${PATH}"

#Get rid of everything we don't need
RUN apt remove -y ${TRANSIENT_SW}
RUN apt autoremove -y --purge && apt clean

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
