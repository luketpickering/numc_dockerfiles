# syntax=docker/dockerfile:1
FROM picker24/buildbox:debian_bullseye-slim
WORKDIR /

RUN mkdir -p /opt/cernlib-src /opt/cernlib/2005
WORKDIR /opt/cernlib-src
RUN test -e /usr/bin/gmake || ln -s /usr/bin/make /usr/bin/gmake
RUN git clone https://github.com/luketpickering/cernlibgcc5-.git
WORKDIR /opt/cernlib-src/cernlibgcc5-
RUN ./build_cernlib.sh
RUN cp -r /opt/cernlib-src/cernlibgcc5-/cernlib_build/2005/bin \
		/opt/cernlib-src/cernlibgcc5-/cernlib_build/2005/lib \
		/opt/cernlib-src/cernlibgcc5-/cernlib_build/2005/include \
     /opt/cernlib/2005
