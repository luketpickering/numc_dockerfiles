FROM picker24/neut533:debian_stretch

ARG TRANSIENT_SW="build-essential"

RUN apt update && apt install --no-install-recommends -y ${TRANSIENT_SW}

# NIWGReWeight
## NIWGReWeight src is not freely available, must take a copy of a local repository
ADD NIWGReWeight /opt/NIWGReWeight-src
WORKDIR /opt/NIWGReWeight-src
RUN make

RUN mkdir /opt/NIWGReWeight
RUN cp /opt/NIWGReWeight-src/libNIWGReWeight.so /opt/NIWGReWeight/
RUN cp /opt/NIWGReWeight-src/*.h /opt/NIWGReWeight/
RUN cp -r /opt/NIWGReWeight-src/inputs /opt/NIWGReWeight/

RUN rm -rf /opt/NIWGReWeight-src

ENV NIWG "/opt/NIWGReWeight"

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

RUN mkdir -p /opt/T2KReWeight/bin /opt/T2KReWeight/lib /opt/T2KReWeight/include
RUN cp /opt/T2KReWeight-src/src/*.h /opt/T2KReWeight/include/
RUN cp /opt/T2KReWeight-src/lib/libT2KReWeight.so /opt/T2KReWeight/lib/
RUN cp /opt/T2KReWeight-src/app/genWeightsFromNeutroot_example /opt/T2KReWeight/bin/

RUN rm -rf /opt/T2KReWeight-src

ENV T2KREWEIGHT "/opt/T2KReWeight"

#Get rid of everything we don't need
RUN apt remove -y ${TRANSIENT_SW}
RUN apt install --no-install-recommends -y libstdc++6
RUN apt autoremove -y --purge && apt clean

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
