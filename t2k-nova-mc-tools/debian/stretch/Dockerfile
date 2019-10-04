FROM localhost/picker24/t2kreweight_v1r27p3:debian_stretch AS T2KREWEIGHT

FROM localhost/picker24/novarwgt_v00.23:debian_stretch

WORKDIR /opt/root/v6-12-06/bin
RUN if [ -e root ]; then echo "Found root"; else ln -s root.exe root; fi

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
          -DCMAKE_CXX_STANDARD=14 \
          -DUSE_NOvARwgt=1 -DCMAKE_BUILD_TYPE=RELEASE
RUN make -j ${N_CORE}
RUN make install
#NUISANCE install process could use some love
RUN cp -r /opt/nuisance-src/nuisance/data \
          /opt/nuisance-src/nuisance/parameters \
          /opt/nuisance/

ENV NUISANCE /opt/nuisance
ENV PATH "${NUISANCE}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${NUISANCE}/lib:${NOVARWGT}/lib:${T2KREWEIGHT}/lib:${NIWG}:${LD_LIBRARY_PATH}"

RUN rm -rf /opt/nuisance-src /opt/nuisance-build

# #Get rid of everything we don't need
RUN apt remove -y ${TRANSIENT_SW}
RUN apt install --no-install-recommends -y libstdc++6 libgfortran3 libgsl2 liblog4cpp5v5 libxml2 vim nano
RUN apt autoremove -y --purge && apt clean

# Some useful envvars

ENV NOVASOUP "1000010010[0.10748284],1000060120[0.66656314],1000080160[0.02987494],1000070140[0.00026273],1000160320[0.00095980],1000170350[0.16110219],1000220480[0.03227276],1000501190[0.00119243],1000200400[0.00026317],1000110230[0.00002598]"
ENV CHTARGET "1000060120[.923076],1000010010[.076924]"
ENV H2OTARGET "1000080160[.888888],1000010010[.111112]"

ENV FLUXES "/var/t2k-nova/fluxes"
ENV NOVANDFLUX_NUMODE_FILE "${FLUXES}/NOvA/FHC_Flux_NOvA_ND_2017.root"
ENV NOVANDFLUX_NUMODE_HIST "flux_numu"

ENV ND280FLUX_NUMODE_FILE "${FLUXES}/T2K/t2kflux_2016_minus250kA.root"
ENV ND280FLUX_NUMODE_HIST "enu_nd280_numu"

ENV SKFLUX_NUMODE_FILE "${FLUXES}/T2K/t2kflux_2016_minus250kA.root"
ENV SKFLUX_NUMODE_HIST "enu_sk_numu"

ENV ACCEPT_MAPS "/var/t2k-nova/accmaps"

ENV T2KNOVASCRIPTS "/var/t2k-nova/scripts"

# Some files for t2k-nova studies

RUN mkdir -p ${FLUXES}
RUN mkdir -p ${ACCEPT_MAPS}
RUN mkdir -p ${T2KNOVASCRIPTS}

ADD fluxes ${FLUXES}
ADD accmaps ${ACCEPT_MAPS}
ADD t2k-nova-scripts ${T2KNOVASCRIPTS}

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
