FROM picker24/root_v6_24_06:debian_bullseye-slim AS gibuu_build
WORKDIR /opt/

RUN mkdir -p /opt/GiBUU-src
WORKDIR /opt/GiBUU-src
RUN wget --content-disposition https://gibuu.hepforge.org/downloads?f=release2021.tar.gz
RUN wget --content-disposition https://gibuu.hepforge.org/downloads?f=buuinput2021.tar.gz
RUN wget --content-disposition https://gibuu.hepforge.org/downloads?f=libraries2021_RootTuple.tar.gz

RUN tar -xzvf buuinput2021.tar.gz
RUN tar -xzvf release2021.tar.gz
RUN tar -xzvf libraries2021_RootTuple.tar.gz

WORKDIR /opt/GiBUU-src/libraries2021/RootTuple
RUN sed -i "s:cmake:cmake -DCMAKE_CXX_STANDARD=17:g" Makefile

WORKDIR /opt/GiBUU-src/release2021

RUN CXXFLAGS=-std=c++17 make buildRootTuple
RUN CXXFLAGS=-std=c++17 make withROOT=1

FROM picker24/root_v6_24_06:debian_bullseye-slim
WORKDIR /

RUN mkdir -p /opt/GiBUU/2021/{bin,buuinput}
COPY --from=gibuu_build /opt/GiBUU-src/release2021/objects/GiBUU.x /opt/GiBUU/2021/bin/
COPY --from=gibuu_build /opt/GiBUU-src/release2021/testRun/jobCards /opt/GiBUU/2021/jobCards/
COPY --from=gibuu_build /opt/GiBUU-src/buuinput2021 /opt/GiBUU/2021/buuinput

ENV GiBUU=/opt/GiBUU/2021
ENV GiBUU_JOBCARDS=/opt/GiBUU/2021/jobCards
ENV GiBUU_BUUINPUTS=/opt/GiBUU/2021/buuinput
ENV PATH=${GiBUU}/bin:${PATH}