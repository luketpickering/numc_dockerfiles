# syntax=docker/dockerfile:1
FROM picker24/neut_563:alma9 AS neutvectconverter_build
WORKDIR /

RUN mkdir -p /opt/neutvect-converter-build
RUN mkdir -p ~/.ssh/
RUN ssh-keyscan github.com > ~/.ssh/known_hosts

WORKDIR /opt
RUN --mount=type=ssh git clone git@github.com:neut-devel/neutvect-converter.git neutvect-converter-src
WORKDIR /opt/neutvect-converter-build

RUN cmake /opt/neutvect-converter-src -DCMAKE_INSTALL_PREFIX=/opt/neutvect-converter/
RUN make install -j 4

WORKDIR /opt/neutvect-converter-src
RUN git rev-parse --short HEAD > /opt/neutvect-converter/git.shorthash

#final image
FROM picker24/neut_563:alma9
WORKDIR /

COPY --from=neutvectconverter_build /opt/neutvect-converter /opt/neutvect-converter

ENV PATH=/opt/neutvect-converter/bin:${PATH} \
    LD_LIBRARY_PATH=/opt/neutvect-converter/lib:/opt/neutvect-converter/lib64:${LD_LIBRARY_PATH}