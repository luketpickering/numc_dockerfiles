# syntax=docker/dockerfile:1
FROM debian:bullseye-slim AS sedbuild
WORKDIR /
RUN apt update && apt upgrade -y

#BUILD_SW
RUN apt install -y --no-install-recommends build-essential automake libtool pkg-config wget ca-certificates

RUN mkdir /build
WORKDIR /build
RUN wget https://ftp.nluug.nl/pub/gnu/sed/sed-4.8.tar.gz
RUN tar -zxvf sed-4.8.tar.gz
RUN mkdir sed-build
WORKDIR /build/sed-build
RUN /build/sed-4.8/configure && make install

FROM debian:bullseye-slim

RUN apt update && apt upgrade -y

#BUILD_SW
RUN apt install -y --no-install-recommends build-essential gfortran cmake automake libtool pkg-config xutils-dev libxml2-utils
#BUILD_LIBS
RUN apt install -y --no-install-recommends libgmp3-dev libxml2-dev libgsl-dev liblog4cpp5-dev libbz2-dev libpcre3-dev liblzma-dev zlib1g-dev libfreetype6-dev libssl-dev libfftw3-dev
#BUILD_XLIBS
RUN apt install -y --no-install-recommends libx11-dev libxpm-dev libxft-dev libxext-dev libglu1-mesa-dev libglew-dev libftgl-dev libxt-dev libmotif-dev libpng-dev libjpeg-dev
#RETREVAL_SW
RUN apt install -y --no-install-recommends git wget subversion ssh
#MISC_SW
RUN apt install -y --no-install-recommends vim nano gdb csh tcsh ed quota python python3-dev python2-dev cvs procmail ca-certificates

COPY --from=sedbuild /usr/local/bin/ /usr/local/bin/