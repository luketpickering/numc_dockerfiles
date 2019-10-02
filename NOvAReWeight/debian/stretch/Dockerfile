FROM picker24/genie_2_12_2:debian_stretch

ARG N_CORE=8

ARG TRANSIENT_SW="build-essential git cmake pkg-config libxml2-dev libgsl-dev liblog4cpp5-dev"

ENV PYTHIA6_LIBRARY ${PYTHIA6}

RUN apt update && apt install --no-install-recommends -y ${TRANSIENT_SW}

# NOvARwgt
## NOvARwgt src is not freely available, must take a copy of a local repository
ADD NOvARwgt /opt/NOvARwgt-src
WORKDIR /opt/NOvARwgt-src/
RUN git checkout v00.23
RUN sed -i "s/cmake_minimum_required(VERSION 3.10)/cmake_minimum_required(VERSION 3.7)/g" CMakeLists.txt

RUN mkdir /opt/NOvARwgt-build
WORKDIR /opt/NOvARwgt-build
RUN cmake /opt/NOvARwgt-src -DCMAKE_INSTALL_PREFIX=/opt/NOvARwgt/v00.23 \
          -DNOVARWGT_USE_NUSIMDATA=OFF -DNOVARWGT_USE_CETLIB=OFF \
          -DNOVARWGT_USE_GENIE=ON -DNOVARWGT_INSTALL_SOURCE=OFF \
          -DCMAKE_BUILD_TYPE=RELEASE
RUN make VERBOSE=1
RUN make install

RUN rm -rf /opt/NOvARwgt-src /opt/NOvARwgt-build

ENV NOVARWGT "/opt/NOvARwgt/v00.23"

# #Get rid of everything we don't need
RUN apt remove -y ${TRANSIENT_SW}
RUN apt install --no-install-recommends -y libstdc++6 libgsl2 liblog4cpp5v5 libxml2
RUN apt autoremove -y --purge && apt clean

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
