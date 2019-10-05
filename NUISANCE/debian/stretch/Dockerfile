FROM picker24/t2kreweight_v1r27p3:debian_stretch AS T2KREWEIGHT

FROM picker24/genie_2_12_2:debian_stretch

# Pull in CERNLIB
COPY --from=T2KREWEIGHT /opt/cernlib /opt/cernlib

ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT "${CERN}/${CERN_LEVEL}"
ENV PATH "${CERN_ROOT}/bin:${PATH}"

# Pull in NEUT
COPY --from=T2KREWEIGHT /opt/neut /opt/neut

ENV NEUT_ROOT "/opt/neut/5.3.3"
ENV PATH "${NEUT_ROOT}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${NEUT_ROOT}/src/reweight:${NEUT_ROOT}/src/neutclass:${LD_LIBRARY_PATH}"
ENV NEUT_CRSDAT "${NEUT_ROOT}/share/crsdat"
ENV NEUT_CARDS "${NEUT_ROOT}/share/Cards"
ENV ROOT_INCLUDE_PATH "${NEUT_ROOT}/include:${NEUT_ROOT}/src/neutclass:${NEUT_ROOT}/src/reweight:${ROOT_INCLUDE_PATH}"

# Pull in NIWGReWeight
COPY --from=T2KREWEIGHT /opt/NIWGReWeight /opt/NIWGReWeight

ENV NIWG "/opt/NIWGReWeight/v1r23p2"
ENV ROOT_INCLUDE_PATH "${NIWG}:${ROOT_INCLUDE_PATH}"

# Pull in T2KReWeight
COPY --from=T2KREWEIGHT /opt/T2KReWeight /opt/T2KReWeight

ENV T2KREWEIGHT "/opt/T2KReWeight/v1r27p3"
ENV ROOT_INCLUDE_PATH "${T2KREWEIGHT}/include:${ROOT_INCLUDE_PATH}"

# NUISANCE tries to include the src directory, symlink to the right one
RUN ln -s ${T2KREWEIGHT}/include ${T2KREWEIGHT}/src

#Start NUISANCE build

ARG N_CORE=8

ARG LEAVEDEV=false

ARG TRANSIENT_SW="build-essential gfortran git cmake pkg-config libxml2-dev libgsl-dev liblog4cpp5-dev"

RUN apt update && apt install --no-install-recommends -y ${TRANSIENT_SW}

RUN mkdir -p /opt/nuisance-src
WORKDIR /opt/nuisance-src
RUN git clone -c http.sslVerify=false \
              https://github.com/NUISANCEMC/nuisance.git
WORKDIR /opt/nuisance-src/nuisance

RUN mkdir /opt/nuisance-build
WORKDIR /opt/nuisance-build
RUN cmake /opt/nuisance-src/nuisance -DCMAKE_INSTALL_PREFIX=/opt/nuisance \
          -DUSE_GENIE=1 -DUSE_NEUT=1 -DUSE_T2K=1 -DUSE_NIWG=1 \
          -DCMAKE_BUILD_TYPE=RELEASE
RUN make -j ${N_CORE}
RUN make install
#NUISANCE install process could use some love
RUN cp -r /opt/nuisance-src/nuisance/data \
          /opt/nuisance-src/nuisance/parameters \
          /opt/nuisance/

ENV NUISANCE /opt/nuisance
ENV PATH "${NUISANCE}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${NUISANCE}/lib:${T2KREWEIGHT}/lib:${NIWG}:${LD_LIBRARY_PATH}"

RUN if [ "${LEAVEDEV}" = "false" ]; then \
        rm -r /opt/nuisance-src; \
    fi; \
    rm -r /opt/nuisance-build

# #Get rid of everything we don't need
RUN if [ "${LEAVEDEV}" = "false" ]; then \
        apt remove -y ${TRANSIENT_SW}; \
        apt install --no-install-recommends -y libstdc++6 libgfortran3 libgsl2 liblog4cpp5v5 libxml2; \
    else \
        apt install -y vim nano gdb; \
    fi

RUN apt autoremove -y --purge && apt clean

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
