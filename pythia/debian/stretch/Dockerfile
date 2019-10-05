FROM picker24/buildbox:latest AS BUILD

# PYTHIA 6.4.28
RUN mkdir -p /opt/pythia6-src
WORKDIR /opt/pythia6-src/
RUN wget --no-check-certificate http://root.cern.ch/download/pythia6.tar.gz
RUN wget --no-check-certificate http://www.hepforge.org/archive/pythia6/pythia-6.4.28.f.gz
RUN gunzip pythia-6.4.28.f.gz
RUN tar xfvz pythia6.tar.gz
RUN mv pythia-6.4.28.f pythia6/pythia6428.f
RUN rm -rf pythia6/pythia6416.f
WORKDIR /opt/pythia6-src/pythia6
RUN ./makePythia6.linuxx8664
RUN mkdir -p /opt/pythia6/6.4.28
RUN mv libPythia6.so /opt/pythia6/6.4.28/libPythia6.so.6.4.28
RUN ln -s /opt/pythia6/6.4.28/libPythia6.so.6.4.28 /opt/pythia6/6.4.28/libPythia6.so

FROM picker24/runbox:latest

COPY --from=BUILD /opt/pythia6 /opt/pythia6

ENV PYTHIA6 /opt/pythia6/6.4.28
ENV LD_LIBRARY_PATH "${PYTHIA6}:${LD_LIBRARY_PATH}"

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
