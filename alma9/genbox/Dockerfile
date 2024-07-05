# syntax=docker/dockerfile:1
FROM picker24/nusystematics_02_00_02:alma9

COPY --from=picker24/t2kreweight_24_05:alma9 /opt/neut /opt/neut

ENV NEUT_VERSION=5.8.0 \
    NEUT_ROOT=/opt/neut/5.8.0
ENV PATH=${NEUT_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH} \
    NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat \
    NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards \
    ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH} \
    PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}

COPY --from=picker24/t2kreweight_24_05:alma9 /opt/t2kreweight /opt/t2kreweight
COPY --from=picker24/t2kreweight_24_05:alma9 /opt/Prob3plusplus /opt/Prob3plusplus

ENV NIWG_VERSION=24.05 \
    T2KREWEIGHT_VERSION=24.05.01
#T2KReWeight is installing NIWG for us
ENV NIWG_ROOT=/opt/t2kreweight/${T2KREWEIGHT_VERSION} \
    T2KReWeight_ROOT=/opt/t2kreweight/${T2KREWEIGHT_VERSION} \
    Prob3plusplus_ROOT=/opt/Prob3plusplus/git_master
ENV PATH=${T2KReWeight_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${T2KReWeight_ROOT}/lib:${Prob3plusplus_ROOT}/lib:${LD_LIBRARY_PATH} \
    CMAKE_PREFIX_PATH=${Prob3plusplus_ROOT}:${CMAKE_PREFIX_PATH}

COPY --from=picker24/nuwro_21_09:alma9 /opt/nuwro /opt/nuwro

ENV NUWRO=/opt/nuwro/21.09.2 \
    PATH=/opt/nuwro/21.09.2/bin:${PATH} \
    ROOT_INCLUDE_PATH=/opt/nuwro/21.09.2/src:${ROOT_INCLUDE_PATH}

COPY --from=picker24/gibuu_jxi24_main:alma9 /opt/GiBUU/jxi24_main /opt/GiBUU/jxi24_main

ENV GiBUU=/opt/GiBUU/jxi24_main \
    GiBUU_JOBCARDS=/opt/GiBUU/jxi24_main/jobCards \
    GiBUU_BUUINPUTS=/opt/GiBUU/jxi24_main/buuinput \
    PATH=/opt/GiBUU/jxi24_main/bin:${PATH}

COPY --from=picker24/achilles_git_master:alma9 /opt/HepMC3/ /opt/HepMC3/
COPY --from=picker24/achilles_git_master:alma9 /opt/NuHepMC_CPPUtils/git_master /opt/NuHepMC_CPPUtils/git_master

COPY --from=picker24/achilles_git_master:alma9 /opt/achilles/git_master /opt/achilles/git_master

ENV ACHILLES=/opt/achilles/git_master \
    NuHepMC_CPPUtils_ROOT=/opt/NuHepMC_CPPUtils/git_master \
    PATH=/opt/achilles/git_master/bin:/opt/NuHepMC_CPPUtils/git_master/bin:/opt/HepMC3/3.3.0/bin:${PATH} \
    LD_LIBRARY_PATH=/opt/achilles/git_master/lib:/opt/achilles/git_master/lib64:/opt/NuHepMC_CPPUtils/git_master/lib:/opt/HepMC3/3.3.0/lib64:${LD_LIBRARY_PATH} \
    CMAKE_PREFIX_PATH=/opt/HepMC3/3.3.0:${CMAKE_PREFIX_PATH} \
    PYTHONPATH=/opt/NuHepMC_CPPUtils/git_master/python/3.9:/opt/HepMC3/3.3.0/lib64/python3.9/site-packages:${PYTHONPATH}