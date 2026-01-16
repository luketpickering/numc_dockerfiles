FROM picker24/buildbox:alma9 AS gibuu_build
WORKDIR /opt/

RUN mkdir -p /opt/GiBUU-src
WORKDIR /opt/GiBUU-src
RUN wget --content-disposition https://gibuu.hepforge.org/downloads?f=release2025.tar.gz
RUN wget --content-disposition https://gibuu.hepforge.org/downloads?f=buuinput2025.tar.gz
RUN wget --content-disposition https://gibuu.hepforge.org/downloads?f=buuinput2025_inMed.tar.gz
RUN wget --content-disposition https://gibuu.hepforge.org/downloads?f=libraries2025_RootTuple.tar.gz
RUN wget --content-disposition https://gibuu.hepforge.org/downloads?f=libraries2025_HEPMC3.tar.gz

RUN tar -xzvf release2025.tar.gz
RUN tar -xzvf buuinput2025.tar.gz
RUN tar -xzvf buuinput2025_inMed.tar.gz
RUN tar -xzvf libraries2025_RootTuple.tar.gz
RUN tar -xzvf libraries2025_HEPMC3.tar.gz

WORKDIR /opt/GiBUU-src/release

RUN make buildRootTuple
RUN make withROOT=1

FROM picker24/buildbox:alma9
WORKDIR /

RUN mkdir -p /opt/GiBUU/2025p1/{bin,buuinput}
COPY --from=gibuu_build /opt/GiBUU-src/release/objects/GiBUU.x /opt/GiBUU/2025p1/bin/
COPY --from=gibuu_build /opt/GiBUU-src/release/testRun/jobCards /opt/GiBUU/2025p1/jobCards/
COPY --from=gibuu_build /opt/GiBUU-src/buuinput /opt/GiBUU/2025p1/buuinput

ENV GiBUU=/opt/GiBUU/2025p1 \
    GiBUU_JOBCARDS=/opt/GiBUU/2025p1/jobCards \
    GiBUU_BUUINPUTS=/opt/GiBUU/2025p1/buuinput \
    PATH=/opt/GiBUU/2025p1/bin:${PATH}