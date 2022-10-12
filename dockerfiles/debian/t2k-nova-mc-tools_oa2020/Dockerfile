# syntax=docker/dockerfile:1
FROM picker24/novarwgt_nova_oa2020:debian_bullseye-slim AS nuisance_build

WORKDIR /opt

# Pull in NEUT
COPY --from=picker24/t2kreweight_oa2020:debian_bullseye-slim /opt/cernlib /opt/cernlib
ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT /opt/cernlib/2005

ENV NEUT_VERSION=5.4.2
COPY --from=picker24/t2kreweight_oa2020:debian_bullseye-slim /opt/neut /opt/neut
ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}
ENV NEUT=/opt/neut/${NEUT_VERSION}
ENV PATH=${NEUT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NEUT}/lib:${LD_LIBRARY_PATH}
ENV NEUT_CRSPATH=/opt/neut/${NEUT_VERSION}/share/neut/crsdat
ENV NEUT_CARDS=/opt/neut/${NEUT_VERSION}/share/neut/Cards
ENV ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH}

#Pull in NIWGReWeight
COPY --from=picker24/t2kreweight_oa2020:debian_bullseye-slim /opt/niwgreweight /opt/niwgreweight
ENV NIWG_VERSION=oa2020
ENV NIWG="/opt/niwgreweight/${NIWG_VERSION}"
ENV NIWGREWEIGHT_INPUTS=${NIWG}/inputs
ENV LD_LIBRARY_PATH=${NIWG}:${LD_LIBRARY_PATH}
ENV ROOT_INCLUDE_PATH=${NIWG}:${ROOT_INCLUDE_PATH}

#Pull in T2KReWeight
COPY --from=picker24/t2kreweight_oa2020:debian_bullseye-slim /opt/t2kreweight /opt/t2kreweight
ENV T2KREWEIGHT_VERSION=oa2020
ENV T2KREWEIGHT="/opt/t2kreweight/${T2KREWEIGHT_VERSION}"
ENV LD_LIBRARY_PATH=${T2KREWEIGHT}/lib:${LD_LIBRARY_PATH}

RUN git clone https://github.com/NUISANCEMC/nuisance.git nuisance-src
WORKDIR /opt/nuisance-src
RUN mkdir /opt/nuisance-build

WORKDIR /opt/nuisance-build
RUN cmake /opt/nuisance-src -DEXPERIMENTS_ENABLED=OFF -DCMAKE_INSTALL_PREFIX=/opt/nuisance
RUN make -j 5
RUN make install

FROM picker24/novarwgt_nova_oa2020:debian_bullseye-slim
WORKDIR /

# Pull in NEUT
COPY --from=picker24/t2kreweight_oa2020:debian_bullseye-slim /opt/cernlib /opt/cernlib
ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT /opt/cernlib/2005

ENV NEUT_VERSION=5.4.2
COPY --from=picker24/t2kreweight_oa2020:debian_bullseye-slim /opt/neut /opt/neut
ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}
ENV NEUT=/opt/neut/${NEUT_VERSION}
ENV PATH=${NEUT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NEUT}/lib:${LD_LIBRARY_PATH}
ENV NEUT_CRSPATH=/opt/neut/${NEUT_VERSION}/share/neut/crsdat
ENV NEUT_CARDS=/opt/neut/${NEUT_VERSION}/share/neut/Cards
ENV ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH}

#Pull in NIWGReWeight
COPY --from=picker24/t2kreweight_oa2020:debian_bullseye-slim /opt/niwgreweight /opt/niwgreweight
ENV NIWG_VERSION=oa2020
ENV NIWG="/opt/niwgreweight/${NIWG_VERSION}"
ENV NIWGREWEIGHT_INPUTS=${NIWG}/inputs
ENV LD_LIBRARY_PATH=${NIWG}:${LD_LIBRARY_PATH}
ENV ROOT_INCLUDE_PATH=${NIWG}:${ROOT_INCLUDE_PATH}

#Pull in T2KReWeight
COPY --from=picker24/t2kreweight_oa2020:debian_bullseye-slim /opt/t2kreweight /opt/t2kreweight
ENV T2KREWEIGHT_VERSION=oa2020
ENV T2KREWEIGHT="/opt/t2kreweight/${T2KREWEIGHT_VERSION}"
ENV LD_LIBRARY_PATH=${T2KREWEIGHT}/lib:${LD_LIBRARY_PATH}

COPY --from=nuisance_build /opt/nuisance/ /opt/nuisance/

ENV NUISANCE=/opt/nuisance/
ENV PATH=${NUISANCE}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NUISANCE}/lib:${LD_LIBRARY_PATH}

ENV FLUXES=/var/t2k-nova/fluxes
ENV T2KNOVASCRIPTS=/var/t2k-nova/scripts

#install some T2K-NOvA inputs
COPY fluxes ${FLUXES}
COPY t2k-nova-scripts ${T2KNOVASCRIPTS}

RUN find ${T2KNOVASCRIPTS} -name "*.sh" -exec chmod +x \{} \;
ENV PATH=${T2KNOVASCRIPTS}/ana/nuisance:${PATH}

ENV NUISANCE_DS_PATH=${T2KNOVASCRIPTS}/ana/nuisance
WORKDIR ${T2KNOVASCRIPTS}/ana/nuisance

RUN BuildDynamicSample T2KNOvAFlatTree.cxx T2KNOvAFlatTree.so
RUN file T2KNOvAFlatTree.so

#Shut GENIE Up
RUN sed -i "s:</messenger_config>:<priority msgstream=\"Pythia6Decay\">FATAL</priority>\n<priority msgstream=\"ResonanceDecay\">FATAL</priority>\n</messenger_config>:g" ${GENIE}/config/Messenger_whisper.xml
