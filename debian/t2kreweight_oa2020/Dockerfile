# syntax=docker/dockerfile:1
FROM picker24/neut_oa2020:debian_bullseye-slim AS niwg_build
WORKDIR /

ENV NIWG_VERSION=oa2020

RUN mkdir -p /opt/niwgreweight/${NIWG_VERSION}

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:t2k-software/NIWGReWeight.git niwgreweight-src
WORKDIR /opt/niwgreweight-src
RUN git checkout Patch/OA2020

RUN make

RUN cp -r /opt/niwgreweight-src/*.h \
          /opt/niwgreweight-src/*.pcm \
          /opt/niwgreweight-src/*.so \
          /opt/niwgreweight-src/inputs \
      /opt/niwgreweight/${NIWG_VERSION}/

ENV NIWG="/opt/niwgreweight/${NIWG_VERSION}"
ENV NIWGREWEIGHT_INPUTS=${NIWG}/inputs
ENV LD_LIBRARY_PATH=${NIWG}:${LD_LIBRARY_PATH}

FROM niwg_build AS t2krw_build
WORKDIR /

ENV T2KREWEIGHT_VERSION=oa2020
ENV T2KREWEIGHT=/opt/t2kreweight-src

RUN mkdir -p /opt/t2kreweight/${T2KREWEIGHT_VERSION}

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:t2k-software/T2KReWeight.git t2kreweight-src
WORKDIR /opt/t2kreweight-src
RUN git checkout Patch/OA2020

RUN ./configure \
      --enable-neut \
          --with-cern=${CERN}/${CERN_LEVEL} \
      --enable-niwg

RUN ENV_CXXFLAGS="$(root-config --cflags) " make autogen-headers
RUN ENV_CXXFLAGS="$(root-config --cflags) " make make-bin-lib-dir
RUN ENV_CXXFLAGS="$(root-config --cflags) " make src

RUN mkdir -p /opt/t2kreweight/${T2KREWEIGHT_VERSION}/bin
RUN mkdir -p /opt/t2kreweight/${T2KREWEIGHT_VERSION}/lib
RUN mkdir -p /opt/t2kreweight/${T2KREWEIGHT_VERSION}/include
RUN ln -s /opt/t2kreweight/${T2KREWEIGHT_VERSION}/include /opt/t2kreweight/${T2KREWEIGHT_VERSION}/src
RUN cp /opt/t2kreweight-src/src/*.h /opt/t2kreweight/${T2KREWEIGHT_VERSION}/include/
RUN cp /opt/t2kreweight-src/lib/libT2KReWeight.so /opt/t2kreweight/${T2KREWEIGHT_VERSION}/lib/

ENV T2KREWEIGHT="/opt/t2kreweight/${T2KREWEIGHT_VERSION}"
ENV LD_LIBRARY_PATH=${T2KREWEIGHT}/lib:${LD_LIBRARY_PATH}

FROM picker24/neut_oa2020:debian_bullseye-slim
WORKDIR /

COPY --from=t2krw_build /opt/niwgreweight /opt/niwgreweight
ENV NIWG_VERSION=oa2020
ENV NIWG="/opt/niwgreweight/${NIWG_VERSION}"
ENV NIWGREWEIGHT_INPUTS=${NIWG}/inputs
ENV LD_LIBRARY_PATH=${NIWG}:${LD_LIBRARY_PATH}

COPY --from=t2krw_build /opt/t2kreweight /opt/t2kreweight
ENV T2KREWEIGHT_VERSION=oa2020
ENV T2KREWEIGHT="/opt/t2kreweight/${T2KREWEIGHT_VERSION}"
ENV LD_LIBRARY_PATH=${T2KREWEIGHT}/lib:${LD_LIBRARY_PATH}