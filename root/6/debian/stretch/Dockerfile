FROM debian:stretch-slim

ARG N_CORE=8

ARG ISMINIMAL
# environment expansion tricks to get container build to be arg-dependent...

ARG BUILD_MINIMAL
ARG BUILD_MAXIMAL
ARG TRANSIENT_SW
ARG INST_SW

RUN echo "BUILD_MINIMAL? ${BUILD_MINIMAL}"
RUN echo "TRANSIENT_SW:  ${TRANSIENT_SW}"
RUN echo "INST_SW:  ${INST_SW}"

RUN apt update && apt install --no-install-recommends -y ${TRANSIENT_SW}

# PYTHIA 6.4.28
RUN mkdir -p /opt/pythia6-src
WORKDIR /opt/pythia6-src/
RUN wget --no-check-certificate http://root.cern.ch/download/pythia6.tar.gz
RUN wget --no-check-certificate http://www.hepforge.org/archive/pythia6/pythia-6.4.28.f.gz
RUN gunzip pythia-6.4.28.f.gz
RUN tar xfvz pythia6.tar.gz
RUN mv pythia-6.4.28.f pythia6/pythia6428.f
RUN rm -rf pythia6/pythia6416.f
WORKDIR /opt/pythia6-src/pythia6
RUN ./makePythia6.linuxx8664
RUN mkdir -p /opt/pythia6/6.4.28
RUN mv libPythia6.so /opt/pythia6/6.4.28/libPythia6.so.6.4.28
RUN ln -s /opt/pythia6/6.4.28/libPythia6.so.6.4.28 /opt/pythia6/6.4.28/libPythia6.so
WORKDIR /opt/
RUN rm -rf /opt/pythia6-src/

ENV PYTHIA6 /opt/pythia6/6.4.28

# ROOT
RUN mkdir -p /opt/root-src
RUN mkdir -p /opt/root-build
RUN git clone -c http.sslVerify=false \
              https://github.com/root-project/root.git /opt/root-src
WORKDIR /opt/root-src
RUN git checkout tags/v6-12-06
WORKDIR /opt/root-build
ENV USE_PARALLEL_MINUIT2=0
RUN cmake /opt/root-src \
  -Dminuit2=ON \
  -Dtmva=OFF -Drootfit=OFF -Dx11=${BUILD_MAXIMAL} -Dxft=${BUILD_MAXIMAL} \
  -Dopengl=${BUILD_MAXIMAL} -Dminimal=${BUILD_MINIMAL} \
  -Dmathmore=ON \
  -Dpythia6=ON -DPYTHIA6_LIBRARY=${PYTHIA6}/libPythia6.so.6.4.28 \
  -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/opt/root/v6-12-06
RUN make -j ${N_CORE}
RUN make install
WORKDIR /opt/root/v6-12-06/bin
# Add a symlink as the minimal install doesn't include the splash screen wrapper.
RUN if [ ! -e root ]; then ln -s root.exe root; fi
RUN rm -rf /opt/root-src /opt/root-build
# Tidy up some stuff ROOT installs needlessly
RUN rm -rf /opt/root/v6-12-06/test /opt/root/v6-12-06/tutorials /opt/root/v6-12-06/README /opt/root/v6-12-06/macros

# Apply effect of running /usr/local/bin/thisroot.sh in the container
ENV LD_LIBRARY_PATH "/opt/root/v6-12-06/lib:${LD_LIBRARY_PATH}"
ENV LIBPATH /opt/root/v6-12-06/lib
ENV JUPYTER_PATH /opt/root/v6-12-06/etc/notebook
ENV PATH "/opt/root/v6-12-06/bin:/opt/root/v6-12-06/sbin:${PATH}"
ENV DYLD_LIBRARY_PATH /opt/root/v6-12-06/lib
ENV PYTHONPATH /opt/root/v6-12-06/lib
ENV SHLIB_PATH /opt/root/v6-12-06/lib
ENV CMAKE_PREFIX_PATH /opt/root/v6-12-06
ENV ROOTSYS /opt/root/v6-12-06

#Get rid of everything we don't need
RUN apt remove -y ${TRANSIENT_SW}
RUN apt install --no-install-recommends -y ${INST_SW}
RUN apt autoremove -y --purge && apt clean

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
