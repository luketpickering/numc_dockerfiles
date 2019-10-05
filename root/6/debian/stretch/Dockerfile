ARG ISMINIMAL=ON

FROM picker24/pythia6_4_28:latest AS PYTHIA

FROM picker24/buildbox:latest AS BUILD

#Pull in pythia
COPY --from=PYTHIA /opt/pythia6 /opt/pythia6

ENV PYTHIA6 "/opt/pythia6/6.4.28"

RUN apt update && apt install --no-install-recommends -y ${TRANSIENT_SW}

# ROOT
RUN mkdir -p /opt/root-src
RUN mkdir -p /opt/root-build
RUN git clone -c http.sslVerify=false \
              https://github.com/root-project/root.git /opt/root-src
WORKDIR /opt/root-src
RUN git checkout tags/v6-12-06
WORKDIR /opt/root-build
ENV USE_PARALLEL_MINUIT2=0
RUN if [ "${ISMINIMAL}" = "ON" ]; then \
      cmake /opt/root-src \
        -Dminuit2=ON \
        -Dtmva=OFF -Drootfit=OFF \
        -Dx11=$OFF -Dxft=$OFF -Dopengl=$OFF \
        -Dminimal=ON \
        -Dmathmore=ON \
        -Dpythia6=ON -DPYTHIA6_LIBRARY=${PYTHIA6}/libPythia6.so.6.4.28 \
        -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/opt/root/v6-12-06 ; \
    else \
      cmake /opt/root-src \
        -Dminuit2=ON \
        -Dmathmore=ON \
        -Dpythia6=ON -DPYTHIA6_LIBRARY=${PYTHIA6}/libPythia6.so.6.4.28 \
        -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/opt/root/v6-12-06 ; \
    fi
RUN make -j ${N_CORE}
RUN make install
WORKDIR /opt/root/v6-12-06/bin
# Add a symlink as the minimal install doesn't include the splash screen wrapper.
RUN if [ ! -e root ]; then ln -s root.exe root; fi

# Tidy up some stuff ROOT installs needlessly
RUN rm -rf /opt/root/v6-12-06/test /opt/root/v6-12-06/tutorials /opt/root/v6-12-06/README /opt/root/v6-12-06/macros

FROM picker24/runbox:latest

COPY --from=BUILD /opt/root /opt/root

# Apply effect of running /usr/local/bin/thisroot.sh in the container
ENV LD_LIBRARY_PATH "/opt/root/v6-12-06/lib:${LD_LIBRARY_PATH}"
ENV LIBPATH /opt/root/v6-12-06/lib
ENV JUPYTER_PATH /opt/root/v6-12-06/etc/notebook
ENV PATH "/opt/root/v6-12-06/bin:/opt/root/v6-12-06/sbin:${PATH}"
ENV DYLD_LIBRARY_PATH /opt/root/v6-12-06/lib
ENV PYTHONPATH /opt/root/v6-12-06/lib
ENV SHLIB_PATH /opt/root/v6-12-06/lib
ENV CMAKE_PREFIX_PATH /opt/root/v6-12-06
ENV ROOTSYS /opt/root/v6-12-06

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
