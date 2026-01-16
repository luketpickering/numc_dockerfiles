#!/bin/bash

set -x
set -e

# cd ../buildbox

# ./buildmultiarch.sh

PLATFORMS=--platform=linux/arm64,linux/amd64
# PUSHLOAD=--push

# PLATFORMS=--platform=linux/arm64
PUSHLOAD=--push

# cd ../hepmc3_3_2
# docker buildx build . -t picker24/hepmc3_3_2:alma9 ${PUSHLOAD} --ssh default ${PLATFORMS} --no-cache
# cd -

# cd ../nuhepmc_git_master
# docker buildx build . -t picker24/nuhepmc_git_master:alma9 ${PUSHLOAD} --ssh default ${PLATFORMS} --no-cache
# cd -

# cd ../achilles_git_dev
# docker buildx build . -t picker24/achilles_git_dev:alma9 ${PUSHLOAD} --ssh default ${PLATFORMS} --no-cache
# cd -

# cd ../gibuu_2025p1
# docker buildx build . -t picker24/gibuu_2025p1:alma9 ${PUSHLOAD} --ssh default ${PLATFORMS} --no-cache
# cd -

# cd ../genie_3_04_02
# docker buildx build . -t picker24/genie_3_04_02:alma9 ${PUSHLOAD} --ssh default ${PLATFORMS} --no-cache
# cd -

cd ../nuwro_25_03
docker buildx build . -t picker24/nuwro_25_03:alma9 ${PUSHLOAD} --ssh default ${PLATFORMS} --no-cache
cd -

# cd ../neut/neut_580
# docker buildx build . -t picker24/neut_580:alma9 ${PUSHLOAD} --ssh default ${PLATFORMS}
# cd -

# cd ../neut/neut580_quickstart
# docker buildx build . -t picker24/neut580_quickstart:alma9 ${PUSHLOAD} --ssh default ${PLATFORMS} --no-cache
# cd -

cd ../genbox
docker buildx build . -t picker24/genbox:alma9 ${PUSHLOAD} --ssh default ${PLATFORMS} --no-cache
