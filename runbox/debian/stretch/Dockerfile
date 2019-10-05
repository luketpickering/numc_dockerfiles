FROM debian:stretch-slim

ARG RUN_LIBS="libstdc++-6-dev libgfortran3 libfreetype6 libpcre3 liblzma5 zlib1g libgsl2 libxml2 libssl1.1 libfftw3-3 liblog4cpp5v5"
ARG RUN_XLIBS="libx11-6 libxpm4 libxft2 libxext6 libglu1-mesa libglew2.0 libftgl2 libpng16-16 libjpeg62-turbo"
ARG RUN_SW="python"


RUN apt update && apt install --no-install-recommends -y \
  ${RUN_LIBS} \
  ${RUN_XLIBS} \
  ${RUN_SW} 

WORKDIR /

ENTRYPOINT ["/bin/bash"]
CMD []
