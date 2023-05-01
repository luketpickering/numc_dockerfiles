# syntax=docker/dockerfile:1
FROM picker24/genie_nova_oa2020:debian_bullseye-slim AS novarwgt_build
WORKDIR /opt/

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts
RUN --mount=type=ssh git clone git@github.com:luketpickering/NOvARwgt.git NOvARwgt-src
WORKDIR /opt/NOvARwgt-src
# RUN git checkout v2.0-dev21

RUN mkdir -p /opt/NOvARwgt-build
WORKDIR /opt/NOvARwgt-build

ENV PYTHIA6_LIBRARY=${PYTHIA6}

RUN cmake /opt/NOvARwgt-src \
          -DCMAKE_INSTALL_PREFIX=/opt/NOvARwgt/v2.0-dev21 \
          -DNOVARWGT_USE_NUSIMDATA=OFF -DNOVARWGT_USE_CETLIB=OFF \
          -DNOVARWGT_USE_GENIE=ON -DNOVARWGT_INSTALL_SOURCE=OFF \
          -DCMAKE_BUILD_TYPE=RELEASE

RUN make install -j 5

FROM picker24/genie_nova_oa2020:debian_bullseye-slim
WORKDIR /opt/

COPY --from=novarwgt_build /opt/NOvARwgt/ /opt/NOvARwgt/

ENV NOVARWGT=/opt/NOvARwgt/v2.0-dev21

ENV NOVARWGT=${NOVARWGT}
ENV NOVARWGT_DATA=${NOVARWGT}/data
ENV LD_LIBRARY_PATH=${NOVARWGT}/lib:${LD_LIBRARY_PATH}