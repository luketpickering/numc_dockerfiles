# syntax=docker/dockerfile:1
FROM picker24/neut_580:alma9 AS neut_build
WORKDIR /

COPY --from=picker24/nuhepmc_git_master:alma9 /opt/HepMC3 /opt/HepMC3
COPY --from=picker24/nuhepmc_git_master:alma9 /opt/NuHepMC_CPPUtils /opt/NuHepMC_CPPUtils

ENV PATH=/opt/HepMC3/3.3.1/bin:${PATH} \
    NuHepMC_CPPUtils_ROOT=/opt/NuHepMC_CPPUtils/git_master \
    LD_LIBRARY_PATH=/opt/NuHepMC_CPPUtils/git_master/lib:/opt/NuHepMC_CPPUtils/git_master/lib64:/opt/HepMC3/3.3.1/lib64:${LD_LIBRARY_PATH} \
    CMAKE_PREFIX_PATH=/opt/HepMC3/3.3.1:${CMAKE_PREFIX_PATH} \
    PYTHONPATH=/opt/HepMC3/3.3.1/lib64/python3.9/site-packages:${PYTHONPATH}

WORKDIR /opt
RUN git clone https://github.com/neut-devel/neutvect-converter.git neutvect-converter-src

WORKDIR /opt/neutvect-converter-build
RUN cmake /opt/neutvect-converter-src -DCMAKE_INSTALL_PREFIX=/opt/neutvect-converter/git_main
RUN make install -j 4

WORKDIR /opt/neutvect-converter-src
RUN git rev-parse --short HEAD > /opt/neutvect-converter/git_main/git.shorthash

#final image
FROM picker24/neut_580:alma9
WORKDIR /

ENV HepMC3_ROOT=/opt/HepMC3/3.3.1 \
    NuHepMC_CPPUtils_ROOT=/opt/NuHepMC_CPPUtils/git_master \
    nvconv_ROOT=/opt/neutvect-converter/git_main \
    PATH=/opt/neutvect-converter/git_main/bin:/opt/NuHepMC_CPPUtils/git_master/bin:/opt/HepMC3/3.3.1/bin:${PATH} \
    LD_LIBRARY_PATH=/opt/neutvect-converter/git_main/lib:/opt/NuHepMC_CPPUtils/git_master/lib:/opt/NuHepMC_CPPUtils/git_master/lib64:/opt/HepMC3/3.3.1/lib64:${LD_LIBRARY_PATH} \
    CMAKE_PREFIX_PATH=/opt/HepMC3/3.3.1:${CMAKE_PREFIX_PATH} \
    PYTHONPATH=/opt/NuHepMC_CPPUtils/git_master/python/3.9:/opt/HepMC3/3.3.1/lib64/python3.9/site-packages:${PYTHONPATH} 

COPY --from=neut_build /opt/neutvect-converter /opt/neutvect-converter
COPY --from=neut_build /opt/HepMC3/ /opt/HepMC3/
COPY --from=picker24/nuhepmc_git_master:alma9 /opt/NuHepMC_CPPUtils /opt/NuHepMC_CPPUtils
