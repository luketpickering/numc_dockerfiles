# syntax=docker/dockerfile:1
FROM picker24/neut_oa2021:centos_7 AS niwg_build
WORKDIR /

ENV NIWG_VERSION=oa2021

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:t2k-software/NIWGReWeight.git niwgreweight-src
WORKDIR /opt/niwgreweight-src
RUN git checkout develop

RUN mkdir -p /opt/niwgreweight-build
WORKDIR /opt/niwgreweight-build
RUN cmake /opt/niwgreweight-src \
	-DCMAKE_INSTALL_PREFIX=/opt/niwgreweight/${NIWG_VERSION}
RUN make && make install

ENV NIWG_ROOT="/opt/niwgreweight/${NIWG_VERSION}"
ENV PATH=${NIWG_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NIWG_ROOT}/lib:${LD_LIBRARY_PATH}

FROM niwg_build AS t2krw_build
WORKDIR /

ENV T2KREWEIGHT_VERSION=oa2021

RUN mkdir -p /opt/t2kreweight/${T2KREWEIGHT_VERSION}

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:t2k-software/T2KReWeight.git t2kreweight-src
WORKDIR /opt/t2kreweight-src
RUN git checkout develop

# RUN mkdir -p /opt/t2kreweight-build
WORKDIR /opt/t2kreweight-build
RUN cmake /opt/t2kreweight-src \
	-DCMAKE_INSTALL_PREFIX=/opt/t2kreweight/${T2KREWEIGHT_VERSION} 
RUN make VERBOSE=1 && make install

FROM picker24/neut_oa2021:centos_7
WORKDIR /

COPY --from=t2krw_build /opt/niwgreweight /opt/niwgreweight
ENV NIWG_VERSION=oa2021
ENV NIWG_ROOT="/opt/niwgreweight/${NIWG_VERSION}"
ENV PATH=${NIWG_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${NIWG_ROOT}/lib:${LD_LIBRARY_PATH}

COPY --from=t2krw_build /opt/t2kreweight /opt/t2kreweight
ENV T2KREWEIGHT_VERSION=oa2021
ENV T2KReWeight_ROOT="/opt/t2kreweight/${T2KREWEIGHT_VERSION}"
ENV PATH=${T2KReWeight_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH=${T2KReWeight_ROOT}/lib:${LD_LIBRARY_PATH}