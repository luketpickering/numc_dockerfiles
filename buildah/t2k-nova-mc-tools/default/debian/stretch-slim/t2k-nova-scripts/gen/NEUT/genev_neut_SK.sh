#!/bin/bash

if [ -z $1 ]; then
  echo "Please pass a number of events to generate."
  exit 1
fi

BEAMMODE="FHC"
NU_PDG=14
FLUX_FILE=${SKFLUX_NUMODE_FILE}
FLUX_HIST=${SKFLUX_NUMODE_HIST}
if [ ! -z $2 ] && [ "${2}" == "RHC" ]; then
  echo "Running with "
  NU_PDG=-14
  FLUX_FILE=${SKFLUX_NUBARMODE_FILE}
  FLUX_HIST=${SKFLUX_NUBARMODE_HIST}
  BEAMMODE="RHC"
fi

NEVS=$1
TARG_N=8
TARG_Z=8
TARG_H=2
TARG_A=16
MDLQE=02
CRSPATH=${NEUT_CRSDAT}

if [ -e SK.${BEAMMODE}.neut.root ]; then
   echo "Already have file: SK.${BEAMMODE}.neut.root, not overwriting."
   exit 1
fi

#if it was sourced as . setup.sh then you can't scrub off the end... assume that
#we are in the correct directory.
if ! echo "${BASH_SOURCE}" | grep "/" --silent; then
  SETUPDIR=$(readlink -f $PWD)
else
  SETUPDIR=$(readlink -f ${BASH_SOURCE%/*})
fi

cp ${SETUPDIR}/stub.card SK.${BEAMMODE}.card.cfg
for i in NEVS \
         TARG_N \
         TARG_Z \
         TARG_H \
         TARG_A \
         NU_PDG \
         FLUX_FILE \
         FLUX_HIST \
         MDLQE \
         CRSPATH; do
  sed -i "s|__${i}__|${!i}|g" SK.${BEAMMODE}.card.cfg
done

mv SK.${BEAMMODE}.card.cfg SK.${BEAMMODE}.card

echo "Running neutroot2 SK.${BEAMMODE}.card SK.${BEAMMODE}.neut.root for ${NEVS} events."
neutroot2 SK.${BEAMMODE}.card SK.${BEAMMODE}.neut.root &> /dev/null

if [ -e SK.${BEAMMODE}.neut.root ]; then
   rm -f fort.77 SK.${BEAMMODE}.card

   PrepareNEUT -i SK.${BEAMMODE}.neut.root \
               -f ${FLUX_FILE},${FLUX_HIST} -G
else
   echo "Failed to produce expected output file: SK.${BEAMMODE}.neut.root"
   exit 1
fi
