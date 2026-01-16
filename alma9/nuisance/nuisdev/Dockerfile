# syntax=docker/dockerfile:1
FROM picker24/nusystematics_02_00_05:alma9 AS build

ENV NEUT_ROOT=/opt/neut/git_master
ENV PATH=${NEUT_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH} \
    NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat \
    NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards \
    ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH} \
    PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}
COPY --from=picker24/neut_git_master:alma9 /opt/neut /opt/neut

ENV NUWRO=/opt/nuwro/25.03
ENV PATH=${NUWRO}/bin:${PATH}
ENV ROOT_INCLUDE_PATH=${NUWRO}/src:${ROOT_INCLUDE_PATH}
COPY --from=picker24/nuwro_21_09:alma9 /opt/nuwro /opt/nuwro

COPY --from=picker24/hepmc3_master:alma9 /opt/HepMC3/ /opt/HepMC3/

ENV CMAKE_PREFIX_PATH=/opt/HepMC3/git_master:${CMAKE_PREFIX_PATH}

WORKDIR /opt
RUN git clone --depth=1 https://github.com/NuHepMC/cpputils.git NuHepMC_CPPUtils-src
WORKDIR /opt/NuHepMC_CPPUtils-build
RUN cmake /opt/NuHepMC_CPPUtils-src \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_INSTALL_PREFIX=/opt/NuHepMC_CPPUtils/git_master \
  -DNuHepMC_CPPUtils_PYTHON_ENABLED=ON \
  && make install -j 4
WORKDIR /opt/NuHepMC_CPPUtils-src
RUN git rev-parse --short HEAD > /opt/NuHepMC_CPPUtils/git_master/git.shorthash
ENV NuHepMC_CPPUtils_ROOT=/opt/NuHepMC_CPPUtils/git_master

WORKDIR /opt
RUN git clone --depth=1 https://github.com/NUISANCEMC/ProSelecta.git ProSelecta-src
WORKDIR /opt/ProSelecta-build
RUN cmake /opt/ProSelecta-src \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_INSTALL_PREFIX=/opt/ProSelecta/git_master \
  && make install -j 4
WORKDIR /opt/ProSelecta-src
RUN git rev-parse --short HEAD > /opt/ProSelecta/git_master/git.shorthash

WORKDIR /opt
RUN git clone --depth=1 https://github.com/neut-devel/neutvect-converter.git nvconv-src
WORKDIR /opt/nvconv-build
RUN cmake /opt/nvconv-src \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_INSTALL_PREFIX=/opt/nvconv/git_master \
  && make install -j 4
WORKDIR /opt/nvconv-src
RUN git rev-parse --short HEAD > /opt/nvconv/git_master/git.shorthash

WORKDIR /opt
RUN git clone --depth=1 https://github.com/NuHepMC/nuwro2hepmc3.git nuwroconv-src
WORKDIR /opt/nuwroconv-build
RUN cmake /opt/nuwroconv-src \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_INSTALL_PREFIX=/opt/nuwroconv/git_master \
  && make install -j 4
WORKDIR /opt/nuwroconv-src
RUN git rev-parse --short HEAD > /opt/nuwroconv/git_master/git.shorthash

RUN mkdir -p /opt/yaml-cpp-build
WORKDIR /opt
RUN wget https://github.com/jbeder/yaml-cpp/archive/refs/tags/0.8.0.tar.gz && tar -zxvf 0.8.0.tar.gz
WORKDIR /opt/yaml-cpp-build
RUN cmake /opt/yaml-cpp-0.8.0 \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/opt/yaml-cpp/v0.8.0 \
  -DYAML_BUILD_SHARED_LIBS=ON \
  && make install -j 4

RUN mkdir -p /opt/pybind11-build
WORKDIR /opt
RUN wget https://github.com/pybind/pybind11/archive/refs/tags/v2.9.2.tar.gz && tar -zxvf v2.9.2.tar.gz
WORKDIR /opt/pybind11-build
RUN cmake /opt/pybind11-2.9.2 \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/opt/pybind11/v2.9.2 \
  -DPYBIND11_INSTALL=ON \
  -DPYBIND11_TEST=OFF \
  && make install -j 4

RUN mkdir -p /opt/Catch2-build
WORKDIR /opt
RUN wget https://github.com/catchorg/Catch2/archive/refs/tags/v3.5.2.tar.gz && tar -zxvf v3.5.2.tar.gz
WORKDIR /opt/Catch2-build
RUN cmake /opt/Catch2-3.5.2 \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/opt/Catch2/v3.5.2 \
  && make install -j 4

WORKDIR /opt
RUN git clone https://github.com/rogerwendell/Prob3plusplus.git Prob3plusplus-src
RUN mkdir -p /opt/Prob3plusplus-build
WORKDIR /opt/Prob3plusplus-build
RUN cmake /opt/Prob3plusplus-src -DCMAKE_INSTALL_PREFIX=/opt/Prob3plusplus/git_master
RUN make install
WORKDIR /opt/Prob3plusplus-src
RUN git rev-parse --short HEAD > /opt/Prob3plusplus/git_master/git.shorthash

#output container image
FROM picker24/nusystematics_02_00_05:alma9

ENV NEUT_ROOT=/opt/neut/git_master
ENV PATH=${NEUT_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH} \
    NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat \
    NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards \
    ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH} \
    PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}
COPY --from=picker24/neut_git_master:alma9 /opt/neut /opt/neut

ENV NUWRO=/opt/nuwro/25.03
ENV PATH=${NUWRO}/bin:${PATH}
ENV ROOT_INCLUDE_PATH=${NUWRO}/src:${ROOT_INCLUDE_PATH}
COPY --from=picker24/nuwro_21_09:alma9 /opt/nuwro /opt/nuwro

COPY --from=build /opt/HepMC3/ /opt/HepMC3/
COPY --from=build /opt/yaml-cpp/ /opt/yaml-cpp/
COPY --from=build /opt/pybind11/ /opt/pybind11/
COPY --from=build /opt/Catch2/ /opt/Catch2/
COPY --from=build /opt/NuHepMC_CPPUtils/ /opt/NuHepMC_CPPUtils/
COPY --from=build /opt/ProSelecta/ /opt/ProSelecta/
COPY --from=build /opt/nvconv/ /opt/nvconv/
COPY --from=build /opt/nuwroconv/ /opt/nuwroconv/
COPY --from=build /opt/Prob3plusplus/ /opt/Prob3plusplus/

#useful for debugging
COPY --from=build /opt/NuHepMC_CPPUtils-src/ /opt/NuHepMC_CPPUtils-src/
COPY --from=build /opt/ProSelecta-src/ /opt/ProSelecta-src/
COPY --from=build /opt/nvconv-src/ /opt/nvconv-src/
COPY --from=build /opt/nuwroconv-src/ /opt/nuwroconv-src/
COPY --from=picker24/hepmc3_master:alma9 /opt/HepMC3-src/ /opt/HepMC3-src/

ENV NuHepMC_CPPUtils_ROOT=/opt/NuHepMC_CPPUtils/git_master \
    ProSelecta_ROOT=/opt/ProSelecta/git_master \
    ProSelecta_INCLUDE_PATH=/opt/ProSelecta/git_master/include:/opt/NuHepMC_CPPUtils/git_master/include:/opt/HepMC3/git_master/include:/usr/include/eigen3 \
    Prob3plusplus_ROOT=/opt/Prob3plusplus/git_master
ENV PATH=${ProSelecta_ROOT}/bin:${NuHepMC_CPPUtils_ROOT}/bin:/opt/HepMC3/git_master/bin:/opt/python/extra/bin:${PATH} \
    LD_LIBRARY_PATH=${ProSelecta_ROOT}/lib:${NuHepMC_CPPUtils_ROOT}/lib:/opt/yaml-cpp/v0.8.0/lib:/opt/nvconv/git_master/lib:/opt/nuwroconv/git_master/lib:${Prob3plusplus_ROOT}/lib:/opt/HepMC3/git_master/lib64:${LD_LIBRARY_PATH} \
    CMAKE_PREFIX_PATH=/opt/Catch2/v3.5.2:/opt/pybind11/v2.9.2:/opt/yaml-cpp/v0.8.0:/opt/nvconv/git_master:/opt/nuwroconv/git_master:${Prob3plusplus_ROOT}:/opt/HepMC3/git_master:${CMAKE_PREFIX_PATH} \
    PYTHONPATH=/opt/ProSelecta/git_master/python/3.9:/opt/NuHepMC_CPPUtils/git_master/python:/opt/HepMC3/git_master/lib64/python3.9/site-packages:${ROOTSYS}/lib/:${PYTHONPATH} \
    JUPYTERLAB_DIR=/opt/python/extra/share/jupyter/lab

RUN pip3 install jupyterlab \
    && pip3 install numpy scipy pandas polars matplotlib \
    && pip3 install tqdm ipywidgets
