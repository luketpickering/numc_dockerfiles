FROM centos:6

ARG N_CORE=8

RUN yum -y update && yum -y install epel-release

ARG TRANSIENT_SW="gcc gcc-c++ gcc-gfortran cmake git gsl-devel wget"

RUN yum -y install ${TRANSIENT_SW}

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
RUN git clone https://github.com/root-project/root.git /opt/root-src
WORKDIR /opt/root-src
RUN git checkout tags/v5-34-38
WORKDIR /opt/root-build
ENV USE_PARALLEL_MINUIT2=0
RUN cmake /opt/root-src -Dminimal=ON \
  -Dminuit2=ON -Dmathmore=ON -Dtmva=OFF -Drootfit=OFF \
  -Dpythia6=ON -DPYTHIA6_LIBRARY=${PYTHIA6}/libPythia6.so.6.4.28 \
  -DCMAKE_INSTALL_PREFIX=/opt/root/5-34-38 -DCMAKE_BUILD_TYPE=RELEASE
RUN make -j ${N_CORE}
RUN make install -j ${N_CORE}
WORKDIR /opt/
RUN rm -rf /opt/root-src /opt/root-build
# Tidy up some stuff ROOT installs needlessly
RUN rm -rf /opt/root/5-34-38/test /opt/root/5-34-38/tutorials /opt/root/5-34-38/README /opt/root/5-34-38/macros

# Apply effect of running /opt/root/5-34-38/bin/thisroot.sh in the container
ENV LD_LIBRARY_PATH "/opt/root/5-34-38/lib:${LD_LIBRARY_PATH}"
ENV LIBPATH /opt/root/5-34-38/lib
ENV JUPYTER_PATH /opt/root/5-34-38/etc/notebook
ENV PATH "/opt/root/5-34-38/bin:/opt/root/5-34-38/sbin:${PATH}"
ENV DYLD_LIBRARY_PATH /opt/root/5-34-38/lib
ENV PYTHONPATH /opt/root/5-34-38/lib
ENV SHLIB_PATH /opt/root/5-34-38/lib
ENV CMAKE_PREFIX_PATH /opt/root/5-34-38
ENV ROOTSYS /opt/root/5-34-38

WORKDIR ${ROOTSYS}/bin
RUN if [ ! -e root ]; then ln -s root.exe root; fi

RUN ldconfig

RUN yum -y remove ${TRANSIENT_SW}

RUN yum install -y gsl libgfortran libstdc++-devel

RUN yum clean all && rm -rf /var/cache/yum

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
