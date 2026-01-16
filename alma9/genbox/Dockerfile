# syntax=docker/dockerfile:1
FROM picker24/genie_3_04_02:alma9

COPY --from=picker24/neut580_quickstart:alma9 /opt/neut /opt/neut
COPY --from=picker24/neut580_quickstart:alma9 /opt/HepMC3/ /opt/HepMC3/
COPY --from=picker24/neut580_quickstart:alma9 /opt/NuHepMC_CPPUtils/git_master /opt/NuHepMC_CPPUtils/git_master
COPY --from=picker24/neut580_quickstart:alma9 /opt/utils/ /opt/utils/

ENV NEUT_VERSION=5.8.0 \
    NEUT_ROOT=/opt/neut/5.8.0 \
    HepMC3_ROOT=/opt/HepMC3/3.3.2 \
    NuHepMC_CPPUtils_ROOT=/opt/NuHepMC_CPPUtils/git_master \
    nvconv_ROOT=/opt/neut/5.8.0

ENV PATH=/opt/utils:${NuHepMC_CPPUtils_ROOT}/bin:${HepMC3_ROOT}/bin:${NEUT_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${NuHepMC_CPPUtils_ROOT}/lib:${NuHepMC_CPPUtils_ROOT}/lib64:${HepMC3_ROOT}/lib64:${NEUT_ROOT}/lib:${LD_LIBRARY_PATH} \
    NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat \
    NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards \
    ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH} \
    PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH} \
    CMAKE_PREFIX_PATH=/opt/HepMC3/3.3.1:${CMAKE_PREFIX_PATH} \
    PYTHONPATH=${NuHepMC_CPPUtils_ROOT}/python/3.9:${HepMC3_ROOT}/lib64/python3.9/site-packages:${PYTHONPATH}

COPY --from=picker24/nuwro_25_03:alma9 /opt/nuwro /opt/nuwro

ENV NUWRO=/opt/nuwro/25.03.1 \
    PATH=/opt/nuwro/25.03.1/bin:${PATH} \
    ROOT_INCLUDE_PATH=/opt/nuwro/25.03.1/src:${ROOT_INCLUDE_PATH}

COPY --from=picker24/gibuu_2025p1:alma9 /opt/GiBUU/2025p1 /opt/GiBUU/2025p1

ENV GiBUU=/opt/GiBUU/2025p1 \
    GiBUU_JOBCARDS=/opt/GiBUU/2025p1/jobCards \
    GiBUU_BUUINPUTS=/opt/GiBUU/2025p1/buuinput \
    PATH=/opt/GiBUU/2025p1/bin:${PATH}

# fix up some whinging in the ROOT cling autoloader
RUN mkdir -p /src/ROOTEGPythia6/ && cd /src/ROOTEGPythia6/ && ln -s /usr/include/root inc
RUN pip3 install jupyterlab==4.1.6 && pip3 install pandas==2.1.4 polars ipywidgets numpy==1.22.4 scipy==1.13.1