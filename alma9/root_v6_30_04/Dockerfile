# syntax=docker/dockerfile:1
FROM picker24/buildbox:alma9 AS pythia6_build
WORKDIR /

RUN mkdir -p /opt/pythia-src /opt/pythia/6.4.28
WORKDIR /opt/pythia-src
RUN wget http://root.cern.ch/download/pythia6.tar.gz \
	&& wget https://pythia.org/download/pythia6/pythia6428.f \
	&& tar xfvz pythia6.tar.gz && mv pythia6428.f pythia6/pythia6428.f \
	&& rm pythia6/pythia6416.f
WORKDIR /opt/pythia-src/pythia6
RUN sed -i "s/int /extern int /g" pythia6_common_address.c \
	&& sed -i "s/char /extern char /g" pythia6_common_address.c \
	&& sed -i "s/extern int pyuppr/int pyuppr/g" pythia6_common_address.c \
	&& sed -i "s/m64/march=native/g" makePythia6.linuxx8664 \
	&& ./makePythia6.linuxx8664 \
	&& mv libPythia6.so /opt/pythia/6.4.28/libPythia6.so

ENV PYTHIA6=/opt/pythia/6.4.28

FROM pythia6_build AS root_build
WORKDIR /

ARG ROOT_VERSION=v6-30-04
ARG NCORES=1

RUN mkdir -p /opt /opt/root/build /opt/root/${ROOT_VERSION}/

RUN git clone --depth  1 --branch ${ROOT_VERSION} https://github.com/root-project/root.git /opt/root-src
WORKDIR /opt/root/build
RUN cmake /opt/root-src \
    -DCMAKE_CXX_STANDARD=17 \
    -Dminuit2=ON \
    -Dminuit2_omp=ON \
    -Darrow=ON \
    -Dclad=OFF \
    -Dmathmore=ON \
    -Dpythia6=ON -DPYTHIA6_LIBRARY=/opt/pythia/6.4.28/libPythia6.so \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/opt/root/${ROOT_VERSION}/ \
    -Droot7=OFF
RUN make -j ${NCORES}
RUN make install

FROM picker24/buildbox:alma9

ARG ROOT_VERSION=v6-30-04

COPY --from=root_build /opt/pythia /opt/pythia

COPY --from=root_build /opt/root/${ROOT_VERSION} /opt/root/${ROOT_VERSION}

ENV ROOTSYS=/opt/root/${ROOT_VERSION}
ENV PATH=${ROOTSYS}/bin:${PATH} \
    PYTHIA6=/opt/pythia/6.4.28 \
    LD_LIBRARY_PATH=${ROOTSYS}/lib:/opt/pythia/6.4.28:${LD_LIBRARY_PATH} \
    Vdt_ROOT=${ROOTSYS} \
    PYTHONPATH=${ROOTSYS}/lib/:${PYTHONPATH}
