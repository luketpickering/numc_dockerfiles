FROM localhost/picker24/neut533:debian_stretch

ARG TRANSIENT_SW="build-essential libgfortran-6-dev"

RUN apt update && apt install --no-install-recommends -y ${TRANSIENT_SW}

# NIWGReWeight
## NIWGReWeight src is not freely available, must take a copy of a local repository
ADD NIWGReWeight /opt/NIWGReWeight-src
WORKDIR /opt/NIWGReWeight-src
RUN make

RUN mkdir -p /opt/NIWGReWeight/v1r23p2
RUN cp /opt/NIWGReWeight-src/libNIWGReWeight.so /opt/NIWGReWeight/v1r23p2/
RUN cp /opt/NIWGReWeight-src/*.h /opt/NIWGReWeight/v1r23p2/
RUN cp -r /opt/NIWGReWeight-src/inputs /opt/NIWGReWeight/v1r23p2/

RUN rm -rf /opt/NIWGReWeight-src

ENV NIWG "/opt/NIWGReWeight/v1r23p2"
ENV ROOT_INCLUDE_PATH "${NIWG}:${ROOT_INCLUDE_PATH}"

# T2KReWeight
## T2KReWeight src is not freely available, must take a copy of a local repository
ADD T2KReWeight /opt/T2KReWeight-src
WORKDIR /opt/T2KReWeight-src

ENV T2KREWEIGHT "/opt/T2KReWeight-src"

RUN ./configure \
      --enable-neut \
          --with-cern=${CERN}/${CERN_LEVEL} \
      --enable-niwg 
RUN ENV_CXXFLAGS=" $(root-config --cflags) " make autogen-headers
RUN ENV_CXXFLAGS=" $(root-config --cflags) " make make-bin-lib-dir
RUN ENV_CXXFLAGS=" $(root-config --cflags) " make src

WORKDIR /opt/T2KReWeight-src/app
RUN g++ genWeightsFromNeutroot_example.cxx \
  -o genWeightsFromNeutroot_example \
  $(root-config --cflags)\
  -I ${T2KREWEIGHT}/src \
  -I ${NIWG} \
  -I ${NEUT_ROOT}/include \
  -I ${NEUT_ROOT}/src/neutclass \
  -I ${NEUT_ROOT}/src/reweight\
  -L ${T2KREWEIGHT}/lib -l T2KReWeight\
  -L ${NEUT_ROOT}/src/reweight -lNReWeight \
  -Wl,--start-group\
    ${NEUT_ROOT}/src/neutclass/neutctrl.so\
    ${NEUT_ROOT}/src/neutclass/neutfsivert.so\
    ${NEUT_ROOT}/src/neutclass/neutrootTreeSingleton.so\
    ${NEUT_ROOT}/src/neutclass/neutvtx.so\
    ${NEUT_ROOT}/src/neutclass/neutfsipart.so\
    ${NEUT_ROOT}/src/neutclass/neutpart.so\
    ${NEUT_ROOT}/src/neutclass/neutvect.so \
    -L ${NEUT_ROOT}/lib/Linux_pc\
    -lneutcore -lnuccorrspl -lnuceff -lpartnuck -lskmcsvc -ltauola\
  -Wl,--end-group\
  -L ${NIWG} -lNIWGReWeight\
  $(root-config --libs) -lgfortran

RUN mkdir -p /opt/T2KReWeight/v1r27p3/bin /opt/T2KReWeight/v1r27p3/lib /opt/T2KReWeight/v1r27p3/include
RUN cp /opt/T2KReWeight-src/src/*.h /opt/T2KReWeight/v1r27p3/include/
RUN cp /opt/T2KReWeight-src/lib/libT2KReWeight.so /opt/T2KReWeight/v1r27p3/lib/
RUN cp /opt/T2KReWeight-src/app/genWeightsFromNeutroot_example /opt/T2KReWeight/v1r27p3/bin/

RUN rm -rf /opt/T2KReWeight-src

ENV T2KREWEIGHT "/opt/T2KReWeight/v1r27p3"
ENV ROOT_INCLUDE_PATH "${T2KREWEIGHT}/include:${ROOT_INCLUDE_PATH}"


#Get rid of everything we don't need
RUN apt remove -y ${TRANSIENT_SW}
RUN apt install --no-install-recommends -y libstdc++6 libgfortran3
RUN apt autoremove -y --purge && apt clean

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
