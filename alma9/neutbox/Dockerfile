# syntax=docker/dockerfile:1
FROM picker24/root_v6_30_04:alma9 AS neut_build
WORKDIR /

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

COPY --from=picker24/nuhepmc_git_master:alma9 /opt/HepMC3 /opt/HepMC3
COPY --from=picker24/nuhepmc_git_master:alma9 /opt/NuHepMC_CPPUtils /opt/NuHepMC_CPPUtils

ENV PATH=/opt/HepMC3/3.3.0/bin:${PATH} \
    NuHepMC_CPPUtils_ROOT=/opt/NuHepMC_CPPUtils/git_master \
    LD_LIBRARY_PATH=/opt/NuHepMC_CPPUtils/git_master/lib:/opt/NuHepMC_CPPUtils/git_master/lib64:/opt/HepMC3/3.3.0/lib64:${LD_LIBRARY_PATH} \
    CMAKE_PREFIX_PATH=/opt/HepMC3/3.3.0:${CMAKE_PREFIX_PATH} \
    PYTHONPATH=/opt/HepMC3/3.3.0/lib64/python3.9/site-packages:${PYTHONPATH}

RUN mkdir -p /opt/neut

# 5.9.0 -------------
ENV NEUT_VERSION=5.9.0

WORKDIR /opt/neut
RUN --mount=type=ssh git clone --branch 5.9.0_alpha --depth 1 git@github.com:neut-devel/neut.git ${NEUT_VERSION}
WORKDIR /opt/neut/${NEUT_VERSION}/src
RUN git submodule update --init
RUN find . -name trapfpe.c -exec sed -i "s/(_FPU_DEFAULT & ~_FPU_EXTENDED) | _FPU_DOUBLE/_FPU_DEFAULT/g" \{} \;
RUN autoreconf -if

RUN mkdir -p /opt/neut-build/${NEUT_VERSION}
WORKDIR /opt/neut-build/${NEUT_VERSION}
RUN /opt/neut/${NEUT_VERSION}/src/configure --prefix=/opt/neut/${NEUT_VERSION} --enable-builtin-cernlib --enable-debug
RUN CERNLIB_NJOBS="-j 4" make install

ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}

RUN git clone https://github.com/neut-devel/neutvect-converter.git

# RUN mkdir /opt/neut-build/${NEUT_VERSION}/neutvect-converter/build
# WORKDIR /opt/neut-build/${NEUT_VERSION}/neutvect-converter/build
# RUN cmake ../ -DCMAKE_INSTALL_PREFIX=/opt/neut/${NEUT_VERSION}
# RUN make install -j 4

# ADD neut-quickstart /opt/neut/${NEUT_VERSION}/bin
# RUN chmod +x /opt/neut/${NEUT_VERSION}/bin/neut-quickstart

# # 5.6.4.3 -------------
# ENV NEUT_VERSION=5.6.4.3

# WORKDIR /opt/neut
# RUN --mount=type=ssh git clone --branch t2k/5.6.4.3 --depth 1 git@github.com:neut-devel/neut.git ${NEUT_VERSION}
# WORKDIR /opt/neut/${NEUT_VERSION}/src
# RUN find . -name trapfpe.c -exec sed -i "s/(_FPU_DEFAULT & ~_FPU_EXTENDED) | _FPU_DOUBLE/_FPU_DEFAULT/g" \{} \;
# RUN autoreconf -if

# RUN mkdir -p /opt/neut-build/${NEUT_VERSION}
# WORKDIR /opt/neut-build/${NEUT_VERSION}
# RUN /opt/neut/${NEUT_VERSION}/src/configure --prefix=/opt/neut/${NEUT_VERSION} --enable-builtin-cernlib --enable-debug
# RUN CERNLIB_NJOBS="-j 4" make install

# ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}

# RUN git clone https://github.com/neut-devel/neutvect-converter.git

# RUN mkdir /opt/neut-build/${NEUT_VERSION}/neutvect-converter/build
# WORKDIR /opt/neut-build/${NEUT_VERSION}/neutvect-converter/build
# RUN cmake ../ -DCMAKE_INSTALL_PREFIX=/opt/neut/${NEUT_VERSION}
# RUN make install -j 4

# ADD neut-quickstart /opt/neut/${NEUT_VERSION}/bin
# RUN chmod +x /opt/neut/${NEUT_VERSION}/bin/neut-quickstart

# #final image
# FROM picker24/root_v6_30_04:alma9
# WORKDIR /

# COPY --from=picker24/nuhepmc_git_master:alma9 /opt/HepMC3 /opt/HepMC3
# COPY --from=picker24/nuhepmc_git_master:alma9 /opt/NuHepMC_CPPUtils /opt/NuHepMC_CPPUtils

# ENV PATH=/opt/HepMC3/3.3.0/bin:${PATH} \
#     NuHepMC_CPPUtils_ROOT=/opt/NuHepMC_CPPUtils/git_master \
#     LD_LIBRARY_PATH=/opt/NuHepMC_CPPUtils/git_master/lib:/opt/NuHepMC_CPPUtils/git_master/lib64:/opt/HepMC3/3.3.0/lib64:${LD_LIBRARY_PATH} \
#     CMAKE_PREFIX_PATH=/opt/HepMC3/3.3.0:${CMAKE_PREFIX_PATH} \
#     PYTHONPATH=/opt/HepMC3/3.3.0/lib64/python3.9/site-packages:${PYTHONPATH}

# COPY --from=neut_build /opt/neut /opt/neut

# RUN mkdir -p /opt/neut/utils
# ADD neut-switcher /opt/neut/utils/

# RUN chmod +x /opt/neut/utils/*
# ENV PATH=/opt/neut/utils/:${PATH} \
#     OMP_NUM_THREADS=1

# ENV ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH}
