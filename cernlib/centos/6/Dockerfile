FROM centos:6

ARG N_CORE=8

RUN yum -y update && yum -y install epel-release

RUN yum -y install gcc gcc-c++ gcc-gfortran libgfortran git wget imake \
                   libXt-devel openmotif-devel libXpm-devel libXext-devel csh\
                   tcsh ed which make

# CERNLIB
RUN mkdir -p /opt/cernlib-src /opt/cernlib
WORKDIR /opt/cernlib-src
RUN git clone https://github.com/luketpickering/cernlibgcc5-.git
WORKDIR /opt/cernlib-src/cernlibgcc5-
RUN ./build_cernlib.sh
RUN mkdir -p /opt/cernlib/2005/
RUN mv /opt/cernlib-src/cernlibgcc5-/cernlib_build/2005/bin /opt/cernlib/2005/
RUN mv /opt/cernlib-src/cernlibgcc5-/cernlib_build/2005/include /opt/cernlib/2005/
RUN mv /opt/cernlib-src/cernlibgcc5-/cernlib_build/2005/lib /opt/cernlib/2005/
RUN rm -rf /opt/cernlib-src

ENV CERN /opt/cernlib
ENV CERN_LEVEL 2005
ENV CERN_ROOT "${CERN}/${CERN_LEVEL}"
ENV PATH "${CERN_ROOT}/bin:${PATH}"

#Get rid of everything we don't need
RUN yum -y remove gcc gcc-c++ gcc-gfortran cmake git wget imake libXt-devel \
                  openmotif-devel libXpm-devel libXext-devel csh tcsh ed \
                  which make

RUN yum -y install libXt openmotif libXpm libXext

RUN yum clean all && rm -rf /var/cache/yum

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
