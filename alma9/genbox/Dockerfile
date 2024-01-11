# syntax=docker/dockerfile:1
FROM picker24/nusystematics_23_11:alma9

COPY --from=picker24/neut_564:alma9 /opt/cernlib /opt/cernlib
ENV CERN=/opt/cernlib \
    CERN_LEVEL=2005 \
    CERN_ROOT=/opt/cernlib/2005

ENV NEUT_VERSION=5.6.4
ENV NEUT_ROOT=/opt/neut/${NEUT_VERSION}
ENV PATH=${NEUT_ROOT}/bin:${PATH} \
    LD_LIBRARY_PATH=${NEUT_ROOT}/lib:${LD_LIBRARY_PATH} \
    NEUT_CRSPATH=${NEUT_ROOT}/share/neut/crsdat \
    NEUT_CARDS=${NEUT_ROOT}/share/neut/Cards \
    ROOT_INCLUDE_PATH=/:${ROOT_INCLUDE_PATH} \
    PKG_CONFIG_PATH=${NEUT_ROOT}:${PKG_CONFIG_PATH}

COPY --from=picker24/neut_564:alma9 /opt/neut /opt/neut

COPY --from=picker24/nuwro_21_09:alma9 /opt/nuwro /opt/nuwro

ENV NUWRO=/opt/nuwro/21.09.2
ENV PATH=${NUWRO}/bin:${PATH}
ENV ROOT_INCLUDE_PATH=${NUWRO}/src:${ROOT_INCLUDE_PATH}