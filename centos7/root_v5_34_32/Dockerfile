# syntax=docker/dockerfile:1
FROM picker24/buildbox:centos7-x86_64 AS pythia6_build
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
	&& sed -i "s/-m64//g" makePythia6.linuxx8664 \
	&& ./makePythia6.linuxx8664 \
	&& mv libPythia6.so /opt/pythia/6.4.28/libPythia6.so

ENV PYTHIA6=/opt/pythia/6.4.28

FROM pythia6_build AS root_build
WORKDIR /

RUN mkdir -p /opt /opt/root/build /opt/root/v5-34-32/

RUN git clone --depth 1 --branch v5-34-32 https://github.com/root-project/root.git /opt/root-src
WORKDIR /opt/root/build
RUN cmake /opt/root-src \
    -DCMAKE_CXX_STANDARD=11 \
    -Dminuit2=ON \
    -Dmathmore=ON \
    -Droofit=ON \
    -Dpythia6=ON -DPYTHIA6_LIBRARY=/opt/pythia/6.4.28/libPythia6.so \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DCMAKE_INSTALL_PREFIX=/opt/root/v5-34-32/
RUN make
RUN make install

FROM picker24/buildbox:centos7-x86_64

COPY --from=root_build /opt/pythia /opt/pythia
ENV PYTHIA6=/opt/pythia/6.4.28
ENV LD_LIBRARY_PATH=${PYTHIA6}:${LD_LIBRARY_PATH}

COPY --from=root_build /opt/root/v5-34-32/ /opt/root/v5-34-32/
ENV ROOTSYS=/opt/root/v5-34-32
ENV PATH=${ROOTSYS}/bin:${PATH}
ENV LD_LIBRARY_PATH=${ROOTSYS}/lib:${LD_LIBRARY_PATH}
