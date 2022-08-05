# syntax=docker/dockerfile:1
FROM picker24/neut_oa2020:centos_7 AS nuisance_build
WORKDIR /

# pull in GENIE
COPY --from=picker24/genie_3_00_06:centos_7 /opt/lhapdf /opt/lhapdf
ENV LHAPDF_VERS=5.9.1
ENV LHAPATH=/opt/lhapdf/${LHAPDF_VERS}
ENV PATH=${LHAPATH}/bin:${PATH}
ENV LD_LIBRARY_PATH=${LHAPATH}/lib:${LD_LIBRARY_PATH}
ENV LHAPDF_INC=${LHAPATH}/include
ENV LHAPDF_LIB=${LHAPATH}/lib

COPY --from=picker24/genie_3_00_06:centos_7 /opt/genie /opt/genie
ENV GENIE_VERSION=3_00_06
ENV GENIE="/opt/genie/${GENIE_VERSION}"
ENV GENIE_REWEIGHT=${GENIE}

ENV PATH=${GENIE}/bin:${PATH}
ENV LD_LIBRARY_PATH=${GENIE}/lib:${LD_LIBRARY_PATH}
ENV ROOT_INCLUDE_PATH=${GENIE}/include/GENIE:${ROOT_INCLUDE_PATH}

ENV GENIE_XSEC_TUNE=G18_02a_00_000
ENV GENIE_XSEC_DIR=/opt/genie/${GENIE_VERSION}/var/genie/xsec/${GENIE_XSEC_TUNE}-k250-e5000-resfixfix
ENV GENIE_XSEC_FILE="${GENIE_XSEC_DIR}/gxspl-min.xml.gz"

ENV GENIE_PHYOPT_DIR=/opt/genie/${GENIE_VERSION}/var/genie/phyopt/dkcharmtau-resfixfix

ENV GXMLPATH=${GENIE_PHYOPT_DIR}:${GENIE_XSEC_DIR}

# pull in NuWro
COPY --from=picker24/nuwro_21_09:centos_7 /opt/nuwro/21_09/ /opt/nuwro/21_09/

ENV NUWRO=/opt/nuwro/21_09/
ENV PATH=/opt/nuwro/21_09/bin:${PATH}

# pull in GiBUU
COPY --from=picker24/gibuu_2021:centos_7 /opt/GiBUU/ /opt/GiBUU/

ENV GiBUU=/opt/GiBUU/2021
ENV GiBUU_JOBCARDS=/opt/GiBUU/2021/jobCards
ENV GiBUU_BUUINPUTS=/opt/GiBUU/2021/buuinput
ENV PATH=${GiBUU}/bin:${PATH}

WORKDIR /opt

RUN git clone https://github.com/NUISANCEMC/nuisance.git nuisance-src
WORKDIR /opt/nuisance-src
RUN git checkout feature/nuis_CLI
RUN mkdir /opt/nuisance-build

WORKDIR /opt/nuisance-build
RUN cmake /opt/nuisance-src -DCMAKE_INSTALL_PREFIX=/opt/nuisance
RUN make -j 5
RUN make install

FROM picker24/neut_oa2020:centos_7
WORKDIR /

# pull in GENIE
COPY --from=picker24/genie_3_00_06:centos_7 /opt/lhapdf /opt/lhapdf
ENV LHAPDF_VERS=5.9.1
ENV LHAPATH=/opt/lhapdf/${LHAPDF_VERS}
ENV PATH=${LHAPATH}/bin:${PATH}
ENV LD_LIBRARY_PATH=${LHAPATH}/lib:${LD_LIBRARY_PATH}
ENV LHAPDF_INC=${LHAPATH}/include
ENV LHAPDF_LIB=${LHAPATH}/lib

COPY --from=picker24/genie_3_00_06:centos_7 /opt/genie /opt/genie
ENV GENIE_VERSION=3_00_06
ENV GENIE="/opt/genie/${GENIE_VERSION}"
ENV GENIE_REWEIGHT=${GENIE}

ENV PATH=${GENIE}/bin:${PATH}
ENV LD_LIBRARY_PATH=${GENIE}/lib:${LD_LIBRARY_PATH}
ENV ROOT_INCLUDE_PATH=${GENIE}/include/GENIE:${ROOT_INCLUDE_PATH}

ENV GENIE_XSEC_TUNE=G18_02a_00_000
ENV GENIE_XSEC_DIR=/opt/genie/${GENIE_VERSION}/var/genie/xsec/${GENIE_XSEC_TUNE}-k250-e5000-resfixfix
ENV GENIE_XSEC_FILE="${GENIE_XSEC_DIR}/gxspl-min.xml.gz"

ENV GENIE_PHYOPT_DIR=/opt/genie/${GENIE_VERSION}/var/genie/phyopt/dkcharmtau-resfixfix

ENV GXMLPATH=${GENIE_PHYOPT_DIR}:${GENIE_XSEC_DIR}

# pull in NuWro
COPY --from=picker24/nuwro_21_09:centos_7 /opt/nuwro/21_09/ /opt/nuwro/21_09/

ENV NUWRO=/opt/nuwro/21_09/
ENV PATH=/opt/nuwro/21_09/bin:${PATH}

# pull in GiBUU
COPY --from=picker24/gibuu_2021:centos_7 /opt/GiBUU/ /opt/GiBUU/

ENV GiBUU=/opt/GiBUU/2021
ENV GiBUU_JOBCARDS=/opt/GiBUU/2021/jobCards
ENV GiBUU_BUUINPUTS=/opt/GiBUU/2021/buuinput
ENV PATH=${GiBUU}/bin:${PATH}

COPY --from=nuisance_build /opt/nuisance/ /opt/nuisance/

ENV NUISANCE=/opt/nuisance/
ENV PATH=${NUISANCE}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NUISANCE}/lib:${LD_LIBRARY_PATH}
