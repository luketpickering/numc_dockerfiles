FROM picker24/root_v6_30_04:alma9 AS build
WORKDIR /

COPY --from=picker24/nuhepmc_git_master:alma9 /opt/HepMC3 /opt/HepMC3
COPY --from=picker24/nuhepmc_git_master:alma9 /opt/NuHepMC_CPPUtils /opt/NuHepMC_CPPUtils

ENV PATH=/opt/HepMC3/3.3.0/bin:${PATH} \
    NuHepMC_CPPUtils_ROOT=/opt/NuHepMC_CPPUtils/git_master \
    LD_LIBRARY_PATH=/opt/HepMC3/3.3.0/lib64:${LD_LIBRARY_PATH} \
    CMAKE_PREFIX_PATH=/opt/HepMC3/3.3.0:${CMAKE_PREFIX_PATH} \
    PYTHONPATH=/opt/HepMC3/3.3.0/lib64/python3.9/site-packages:${PYTHONPATH}

WORKDIR /opt/
RUN git clone --depth  1 --branch process_grouping https://github.com/AchillesGen/Achilles.git achilles-src
RUN mkdir achilles-build
WORKDIR /opt/achilles-build
RUN cmake /opt/achilles-src -DUSE_ROOT=ON -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/opt/achilles/git_master \
    && make install -j 4

WORKDIR /opt/achilles-src
RUN git rev-parse --short HEAD > /opt/achilles/git_master/git.shorthash

FROM picker24/root_v6_30_04:alma9
WORKDIR /

COPY --from=picker24/nuhepmc_git_master:alma9 /opt/HepMC3 /opt/HepMC3
COPY --from=picker24/nuhepmc_git_master:alma9 /opt/NuHepMC_CPPUtils /opt/NuHepMC_CPPUtils

COPY --from=build /opt/achilles/git_master /opt/achilles/git_master

ENV ACHILLES=/opt/achilles/git_master \
    NuHepMC_CPPUtils_ROOT=/opt/NuHepMC_CPPUtils/git_master \
    PATH=/opt/achilles/git_master/bin:/opt/NuHepMC_CPPUtils/git_master/bin:/opt/HepMC3/3.3.0/bin:${PATH} \
    LD_LIBRARY_PATH=/opt/achilles/git_master/lib:/opt/achilles/git_master/lib64:/opt/NuHepMC_CPPUtils/git_master/lib:/opt/HepMC3/3.3.0/lib64:${LD_LIBRARY_PATH} \
    CMAKE_PREFIX_PATH=/opt/HepMC3/3.3.0:${CMAKE_PREFIX_PATH} \
    PYTHONPATH=/opt/NuHepMC_CPPUtils/git_master/python/3.9:/opt/HepMC3/3.3.0/lib64/python3.9/site-packages:${PYTHONPATH}