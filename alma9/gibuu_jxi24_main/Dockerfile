FROM picker24/root_v6_30_04:alma9 AS gibuu_build
WORKDIR /opt/

RUN mkdir -p /opt/GiBUU-src
WORKDIR /opt/GiBUU-src
RUN git clone --depth  1 --branch main https://github.com/jxi24/GiBUU.git release2023
RUN wget --content-disposition https://gibuu.hepforge.org/downloads?f=buuinput2023.tar.gz
RUN wget --content-disposition https://gibuu.hepforge.org/downloads?f=libraries2023_RootTuple.tar.gz

RUN tar -xzvf buuinput2023.tar.gz
RUN tar -xzvf libraries2023_RootTuple.tar.gz

WORKDIR /opt/GiBUU-src/libraries2023/RootTuple
RUN sed -i "s:cmake:cmake -DCMAKE_CXX_STANDARD=17:g" Makefile

WORKDIR /opt/GiBUU-src/release2023

RUN rm /opt/GiBUU-src/libraries2023/RootTuple/RootTuple-master/cmake/Modules/FindROOT.cmake
RUN mkdir -p /opt/GiBUU-src/release2023/objects/LIB/lib
RUN CXXFLAGS="-std=c++17 -I$(root-config --incdir)" make buildRootTuple
RUN CXXFLAGS=-std=c++17 make withROOT=1

FROM picker24/root_v6_30_04:alma9
WORKDIR /

RUN mkdir -p /opt/GiBUU/jxi24_main/{bin,buuinput}
COPY --from=gibuu_build /opt/GiBUU-src/release2023/objects/GiBUU.x /opt/GiBUU/jxi24_main/bin/
COPY --from=gibuu_build /opt/GiBUU-src/release2023/testRun/jobCards /opt/GiBUU/jxi24_main/jobCards/
COPY --from=gibuu_build /opt/GiBUU-src/buuinput2023 /opt/GiBUU/jxi24_main/buuinput

ENV GiBUU=/opt/GiBUU/jxi24_main \
    GiBUU_JOBCARDS=/opt/GiBUU/jxi24_main/jobCards \
    GiBUU_BUUINPUTS=/opt/GiBUU/jxi24_main/buuinput \
    PATH=/opt/GiBUU/jxi24_main/bin:${PATH}