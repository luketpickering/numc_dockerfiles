# syntax=docker/dockerfile:1
FROM picker24/genie_2_12_10:centos_7 AS nuisance_build

WORKDIR /opt

RUN git clone https://github.com/NUISANCEMC/nuisance.git nuisance-src
WORKDIR /opt/nuisance-src
RUN git checkout feature/nuis_CLI
RUN mkdir /opt/nuisance-build

WORKDIR /opt/nuisance-build
RUN cmake /opt/nuisance-src -DCMAKE_INSTALL_PREFIX=/opt/nuisance
RUN make -j 5
RUN make install

FROM picker24/genie_2_12_10:centos_7
WORKDIR /

COPY --from=nuisance_build /opt/nuisance/ /opt/nuisance/

ENV NUISANCE=/opt/nuisance/
ENV PATH=${NUISANCE}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NUISANCE}/lib:${LD_LIBRARY_PATH}
