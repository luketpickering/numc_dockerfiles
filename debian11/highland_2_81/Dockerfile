FROM picker24/buildbox:debian_bullseye-slim AS psyche_build
WORKDIR /

ARG ND280ARCH

ENV HIGHLANDMASTERVER=2.82

ENV ND280_ROOT=/opt/nd280

RUN mkdir -p ${ND280_ROOT}
WORKDIR ${ND280_ROOT}

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan git.t2k.org > ~/.ssh/known_hosts

RUN --mount=type=ssh git clone git@git.t2k.org:nd280/pilot/nd280SoftwarePilot.git
WORKDIR ${ND280_ROOT}/nd280SoftwarePilot
RUN git checkout stable && ./configure.sh

ENV ND280_GIT="git@git.t2k.org:nd280/"
ENV ND280_DOWNLOADS="http://nd280.lancs.ac.uk/downloads"

ENV GIT_SSH_COMMAND="ssh -o ControlMaster=auto -o ControlPath=/tmp/%C -o ControlPersist=3600 "

ENV ND280PILOT_ROOT=${ND280_ROOT}
ENV PATH=${ND280PILOT_ROOT}/nd280SoftwarePilot/scripts:${PATH}
ENV CMAKE_PREFIX_PATH=${ND280PILOT_ROOT}:${CMAKE_PREFIX_PATH}
ENV ND280_SYSTEM=Linux-Debian_GNU.Linux_11-gcc_10-${ND280ARCH}

WORKDIR ${ND280_ROOT}

RUN --mount=type=ssh git clone git@git.t2k.org:nd280/highland2Software/highland2SoftwarePilot.git
WORKDIR ${ND280_ROOT}/highland2SoftwarePilot
RUN git checkout stable

ENV PATH=${ND280_ROOT}/highland2SoftwarePilot/scripts:${PATH}
ENV ROOTROOT=${ROOTSYS}
ENV ROOT_VERSION_MAJOR=6
ENV ND280PROD=prod6T

RUN --mount=type=ssh highland-install -r -p ${ND280PROD} ${HIGHLANDMASTERVER}

ENV ND280SOFTWAREPOLICY_ROOT=${ND280_ROOT}/nd280SoftwarePolicy_master

