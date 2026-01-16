FROM picker24/hepmc3_3_2:alma9 AS build
WORKDIR /

WORKDIR /opt
RUN git clone --depth=1 https://github.com/NuHepMC/cpputils.git NuHepMC_CPPUtils-src
WORKDIR /opt/NuHepMC_CPPUtils-build
RUN cmake /opt/NuHepMC_CPPUtils-src \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/opt/NuHepMC_CPPUtils/git_master \
  -DNuHepMC_CPPUtils_BUILTIN_HEPMC3=OFF \
  -DNuHepMC_CPPUtils_PYTHON_ENABLED=ON \
  -DNuHepMC_CPPUtils_PROTOBUF_INTERFACE=ON \
  && make install
WORKDIR /opt/NuHepMC_CPPUtils-src

RUN git rev-parse --short HEAD > /opt/NuHepMC_CPPUtils/git_master/git.shorthash

FROM picker24/hepmc3_3_2:alma9 
WORKDIR /

COPY --from=build /opt/NuHepMC_CPPUtils/git_master /opt/NuHepMC_CPPUtils/git_master

ENV NuHepMC_CPPUtils_ROOT=/opt/NuHepMC_CPPUtils/git_master \
    PATH=/opt/NuHepMC_CPPUtils/git_master/bin:${PATH} \
    LD_LIBRARY_PATH=/opt/NuHepMC_CPPUtils/git_master/lib:/opt/NuHepMC_CPPUtils/git_master/lib64:${LD_LIBRARY_PATH} \
    PYTHONPATH=/opt/NuHepMC_CPPUtils/git_master/python/3.9:${PYTHONPATH}