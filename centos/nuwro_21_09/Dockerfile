FROM picker24/root_v6_24_06:centos_7 AS nuwro_build
WORKDIR /

WORKDIR /opt/
RUN git clone https://github.com/NuWro/nuwro.git nuwro-src
WORKDIR /opt/nuwro-src
RUN git checkout nuwro_21.09
RUN sed -i "s:-lPythia6:-L${PYTHIA6} -lPythia6:g" Makefile
RUN make

FROM picker24/root_v6_24_06:centos_7
WORKDIR /

RUN mkdir -p /opt/nuwro/21_09/src/dis
RUN mkdir -p /opt/nuwro/21_09/src/espp
RUN mkdir -p /opt/nuwro/21_09/src/sf
RUN mkdir -p /opt/nuwro/21_09/src/rpa
RUN mkdir -p /opt/nuwro/21_09/src/rew
COPY --from=nuwro_build /opt/nuwro-src/data /opt/nuwro/21_09/data
COPY --from=nuwro_build /opt/nuwro-src/bin /opt/nuwro/21_09/bin
COPY --from=nuwro_build /opt/nuwro-src/src/*.h /opt/nuwro/21_09/src/
COPY --from=nuwro_build /opt/nuwro-src/src/dis/*.h /opt/nuwro/21_09/src/dis/
COPY --from=nuwro_build /opt/nuwro-src/src/espp/*.h /opt/nuwro/21_09/src/espp/
COPY --from=nuwro_build /opt/nuwro-src/src/sf/*.h /opt/nuwro/21_09/src/sf/
COPY --from=nuwro_build /opt/nuwro-src/src/rpa/*.h /opt/nuwro/21_09/src/rpa/
COPY --from=nuwro_build /opt/nuwro-src/src/rew/*.h /opt/nuwro/21_09/src/rew/

ENV NUWRO=/opt/nuwro/21_09/
ENV PATH=/opt/nuwro/21_09/bin:${PATH}
ENV ROOT_INCLUDE_PATH=/opt/nuwro/21_09/src:${ROOT_INCLUDE_PATH}