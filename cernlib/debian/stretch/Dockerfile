FROM picker24/buildbox:latest AS BUILD

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

FROM picker24/runbox:latest

COPY --from=BUILD /opt/cernlib /opt/cernlib

ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT "${CERN}/${CERN_LEVEL}"
ENV PATH "${CERN_ROOT}/bin:${PATH}"

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
