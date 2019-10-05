FROM picker24/root_5:centos_6

ARG N_CORE=8

ARG TRANSIENT_SW="gcc gcc-c++ gcc-gfortran cmake git"

RUN yum -y update && yum -y install ${TRANSIENT_SW}

RUN mkdir -p /opt/nuisance-src
WORKDIR /opt/nuisance-src
RUN git clone https://github.com/NUISANCEMC/nuisance.git
WORKDIR /opt/nuisance-src/nuisance

RUN mkdir /opt/nuisance-build
WORKDIR /opt/nuisance-build
RUN cmake /opt/nuisance-src/nuisance -DCMAKE_INSTALL_PREFIX=/opt/nuisance \
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

RUN yum remove -y ${TRANSIENT_SW}}
RUN yum clean all && rm -rf /var/cache/yum

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
