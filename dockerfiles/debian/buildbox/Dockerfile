# syntax=docker/dockerfile:1
FROM debian:bullseye-slim
WORKDIR /
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