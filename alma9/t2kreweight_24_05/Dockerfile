# syntax=docker/dockerfile:1
FROM picker24/neut_580:alma9 AS t2krw_build
WORKDIR /

WORKDIR /opt
RUN git clone https://github.com/rogerwendell/Prob3plusplus.git Prob3plusplus-src
RUN mkdir -p /opt/Prob3plusplus-build
WORKDIR /opt/Prob3plusplus-build
RUN cmake /opt/Prob3plusplus-src -DCMAKE_INSTALL_PREFIX=/opt/Prob3plusplus/git_master
RUN make install
WORKDIR /opt/Prob3plusplus-src
RUN git rev-parse --short HEAD > /opt/Prob3plusplus/git_master/git.shorthash

ENV Prob3plusplus_ROOT=/opt/Prob3plusplus/git_master

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

ENV T2KREWEIGHT_VERSION=24.05.02

RUN mkdir -p /opt/t2kreweight/${T2KREWEIGHT_VERSION}

WORKDIR /opt
RUN --mount=type=ssh git clone --depth 1 --branch ${T2KREWEIGHT_VERSION} git@github.com:t2k-software/T2KReWeight.git t2kreweight-src

RUN mkdir -p /opt/t2kreweight-build
WORKDIR /opt/t2kreweight-build
RUN --mount=type=ssh cmake /opt/t2kreweight-src \
  -DCMAKE_INSTALL_PREFIX=/opt/t2kreweight/${T2KREWEIGHT_VERSION} \
  -DNIWG_ENABLED=ON \
  -DBUILTIN_NIWG_ENABLED=ON \
  -DNEUT_ENABLED=ON \
  -DGEANTReWeight_ENABLED=OFF \
  -DOAAnalysisReader_ENABLED=OFF \
  -DProb3plusplus_ENABLED=ON \
  -DCMAKE_BUILD_TYPE=Release
RUN make install -j 4

WORKDIR /opt/t2kreweight-src
RUN git rev-parse --short HEAD > /opt/t2kreweight/${T2KREWEIGHT_VERSION}/git.shorthash

FROM picker24/neut_580:alma9
WORKDIR /

COPY --from=t2krw_build /opt/t2kreweight /opt/t2kreweight
COPY --from=t2krw_build /opt/Prob3plusplus /opt/Prob3plusplus

ENV NIWG_VERSION=24.05 \
    T2KREWEIGHT_VERSION=24.05.02
#T2KReWeight is installing NIWG for us
ENV NIWG_ROOT=/opt/t2kreweight/${T2KREWEIGHT_VERSION} \
    T2KReWeight_ROOT=/opt/t2kreweight/${T2KREWEIGHT_VERSION} \
    Prob3plusplus_ROOT=/opt/Prob3plusplus/git_master
ENV PATH=${T2KReWeight_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${T2KReWeight_ROOT}/lib:${Prob3plusplus_ROOT}/lib:${LD_LIBRARY_PATH} \
    CMAKE_PREFIX_PATH=${Prob3plusplus_ROOT}:${CMAKE_PREFIX_PATH}
