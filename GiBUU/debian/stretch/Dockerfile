FROM localhost/picker24/root_6_12_6:debian_stretch

ARG N_CORE=8

ARG TRANSIENT_SW="build-essential gfortran wget git cmake libbz2-dev"

RUN apt update && apt install --no-install-recommends -y ${TRANSIENT_SW}

RUN mkdir -p /opt/RootTuple-src
WORKDIR /opt/RootTuple-src
RUN git clone -c http.sslVerify=false \
              https://github.com/davidchall/RootTuple.git
WORKDIR /opt/RootTuple-src/RootTuple
RUN git checkout 1.0.0
RUN sed -i "s/add_subdirectory (docs)/#add_subdirectory (docs)/g" CMakeLists.txt

RUN mkdir -p /opt/RootTuple-build
WORKDIR /opt/RootTuple-build
RUN cmake /opt/RootTuple-src/RootTuple\
          -DCMAKE_INSTALL_PREFIX=/opt/RootTuple/1.0.0 \
          -DCMAKE_BUILD_TYPE=RELEASE
RUN make -j ${N_CORE}
RUN make install

RUN rm -r /opt/RootTuple-src
RUN rm -r /opt/RootTuple-build

ENV ROOTTUPLE /opt/RootTuple/1.0.0
ENV PATH "${ROOTTUPLE}/bin:${PATH}"
ENV LD_LIBRARY_PATH "${ROOTTUPLE}/lib:${LD_LIBRARY_PATH}"

RUN mkdir -p /opt/GiBUU-src
WORKDIR /opt/GiBUU-src
RUN wget --no-check-certificate \
          https://gibuu.hepforge.org/downloads?f=release2019.tar.gz \
          -O release2019.tar.gz
RUN tar -xzvf release2019.tar.gz
RUN rm -r release release2019.tar.gz

RUN mkdir -p /opt/GiBUU/2019
WORKDIR /opt/GiBUU/2019
RUN wget --no-check-certificate \
          https://gibuu.hepforge.org/downloads?f=buuinput2019.tar.gz \
          -O buuinput2019.tar.gz
RUN tar -xzvf buuinput2019.tar.gz
RUN rm -r buuinput buuinput2019.tar.gz

WORKDIR /opt/GiBUU-src/release2019
RUN make withROOT=1 FORT=gfortran MODE=lto
RUN mkdir -p /opt/GiBUU/2019/bin /opt/GiBUU/2019/share
RUN cp /opt/GiBUU-src/release2019/testRun/GiBUU.x /opt/GiBUU/2019/bin/GiBUU
RUN cp -r /opt/GiBUU-src/release2019/testRun/jobCards /opt/GiBUU/2019/share

RUN rm -r /opt/GiBUU-src

ENV GIBUU /opt/GiBUU/2019
ENV GIBUU_CARDS /opt/GiBUU/2019/share/jobCards
ENV BUUINPUTS /opt/GiBUU/2019/buuinput

# #Get rid of everything we don't need
RUN apt remove -y ${TRANSIENT_SW}
RUN apt install --no-install-recommends -y libgfortran3 libbz2-1.0
RUN apt autoremove -y --purge && apt clean

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
