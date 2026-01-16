# syntax=docker/dockerfile:1
FROM picker24/genbox:alma9 AS build

WORKDIR /opt/
RUN git clone https://github.com/NUISANCEMC/nuisance3.git nuisance3-src
RUN mkdir nuisance3-build
WORKDIR /opt/nuisance3-build
RUN cmake /opt/nuisance3-src \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/opt/nuisance3/git_master \
      -DNUISANCE_LEGACY_INTERFACE=ON \
    && make install -j 4

#output container image
FROM picker24/genbox:alma9

COPY --from=build /opt/nuisance3/ /opt/nuisance3/
COPY --from=build /opt/nuisance3-src/data /opt/nuisance3/

ADD notebooks /opt/nuisance3/

ENV NUISANCE3_ROOT=/opt/nuisance3/git_master \
    NUISANCE3_VERSION=3.0.0 \
    ProSelecta_INCLUDE_PATH=/opt/nuisance3/git_master/include:/opt/HepMC3/3.3.0/include:/usr/include/eigen3

ENV LD_LIBRARY_PATH=${NUISANCE3_ROOT}/lib:${NUISANCE3_ROOT}/lib64:/opt/yaml-cpp/v0.8.0/lib:/opt/nvconv/git_master/lib:/opt/nuwroconv/git_master/lib:${LD_LIBRARY_PATH} \
    CMAKE_PREFIX_PATH=${NUISANCE3_ROOT}:/${CMAKE_PREFIX_PATH} \
    PYTHONPATH=${NUISANCE3_ROOT}/python/3.9:${NUISANCE3_ROOT}/lib:${NUISANCE3_ROOT}/lib64:${PYTHONPATH} \
    NUISANCEDB=${NUISANCE3_ROOT}/data

RUN pip3 install jupyterlab \
    && pip3 install numpy scipy pandas polars matplotlib \
    && pip3 install tqdm ipywidgets
