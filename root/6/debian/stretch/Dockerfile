FROM debian:stretch-slim

ARG N_CORE=8

ARG TRANSIENT_SW="build-essential gfortran cmake git python wget libpcre3-dev liblz4-dev liblzma-dev zlib1g-dev libfreetype6-dev libx11-dev libxpm-dev libxft-dev libxext-dev libpng16-16 libjpeg62-turbo"

RUN apt update && apt install --no-install-recommends -y ${TRANSIENT_SW}

# GSL
RUN mkdir -p /opt/gsl-src
WORKDIR /opt/gsl-src
RUN wget ftp://ftp.gnu.org/gnu/gsl/gsl-2.6.tar.gz -O gsl-2.6.tar.gz
RUN tar -zxvf gsl-2.6.tar.gz
RUN mkdir -p /opt/gsl-build
WORKDIR /opt/gsl-build
RUN /opt/gsl-src/gsl-2.6/configure --prefix=/opt/gsl
RUN make -j ${N_CORE}
RUN make install
RUN rm -rf /opt/gsl-src /opt/gsl-build

ENV GSL_ROOT /opt/gsl
ENV GSL_INC /opt/gsl/include
ENV GSL_LIB /opt/gsl/lib
ENV PATH "${GSL_ROOT}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${GSL_LIB}:${LD_LIBRARY_PATH}"

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
RUN mkdir -p /opt/pythia6
RUN mv libPythia6.so /opt/pythia6/libPythia6.so.6.4.28
RUN ln -s /opt/pythia6/libPythia6.so.6.4.28 /opt/pythia6/libPythia6.so
WORKDIR /opt/
RUN rm -rf /opt/pythia6-src/

ENV PYTHIA6 /opt/pythia6

# ROOT
RUN mkdir -p /opt/root-src
RUN mkdir -p /opt/root-build
RUN git clone -c http.sslVerify=false \
              https://github.com/root-project/root.git /opt/root-src
WORKDIR /opt/root-src
RUN git checkout tags/v6-16-00
WORKDIR /opt/root-build
ENV USE_PARALLEL_MINUIT2=0
RUN cmake /opt/root-src \
  -Dminuit2=ON \
  -Dpythia6=ON -DPYTHIA6_LIBRARY=${PYTHIA6}}/libPythia6.so.6.4.28 \
  -DGSL_ROOT_DIR=${GSL_ROOT} \
  -DGSL_CONFIG_EXECUTABLE=${GSL_ROOT}/bin/gsl-config \
  -Droot7=OFF \
  -DCMAKE_BUILD_TYPE=RELEASE
RUN make -j ${N_CORE}
RUN make install
WORKDIR /opt/
RUN rm -rf /opt/root-src /opt/root-build
# Tidy up some stuff ROOT installs needlessly
RUN rm -rf /usr/local/test /usr/local/tutorials /usr/local/README /usr/local/macros

# Apply effect of running /usr/local/bin/thisroot.sh in the container
ENV LD_LIBRARY_PATH "/usr/local/lib:${LD_LIBRARY_PATH}"
ENV LIBPATH /usr/local/lib
ENV JUPYTER_PATH /usr/local/etc/notebook
ENV PATH "/usr/local/bin:/usr/local/sbin:${PATH}"
ENV DYLD_LIBRARY_PATH /usr/local/lib
ENV PYTHONPATH /usr/local/lib
ENV SHLIB_PATH /usr/local/lib
ENV CMAKE_PREFIX_PATH /usr/local
ENV ROOTSYS /usr/local

#Get rid of everything we don't need
RUN apt remove -y ${TRANSIENT_SW}
RUN apt install --no-install-recommends -y libstdc++-6-dev libgfortran3 libfreetype6 libpcre3 liblz4 liblzma zlib1g libx11-6 libxpm4 libxft2 libxext6
RUN apt autoremove -y --purge && apt clean

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
