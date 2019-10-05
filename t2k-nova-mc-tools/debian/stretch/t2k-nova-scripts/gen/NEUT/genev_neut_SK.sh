#!/bin/bash

if [ -z $1 ]; then
  echo "Please pass a number of events to generate."
  exit 1
fi

NEVS=$1
TARG_N=8
TARG_Z=8
TARG_H=2
TARG_A=16
NU_PDG=14
FLUX_FILE=${SKFLUX_NUMODE_FILE}
FLUX_HIST=${SKFLUX_NUMODE_HIST}
MDLQE=02
CRSPATH=${NEUT_CRSDAT}

#if it was sourced as . setup.sh then you can't scrub off the end... assume that
#we are in the correct directory.
if ! echo "${BASH_SOURCE}" | grep "/" --silent; then
  SETUPDIR=$(readlink -f $PWD)
else
  SETUPDIR=$(readlink -f ${BASH_SOURCE%/*})
fi

echo ${SETUPDIR}

cp ${SETUPDIR}/stub.card SK.card.cfg
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
  sed -i "s|__${i}__|${!i}|g" SK.card.cfg
done

mv SK.card.cfg SK.card

echo "Running neutroot2 SK.card SK.neut.root for ${NEVS} events."
neutroot2 SK.card SK.neut.root &> /dev/null

if [ -e SK.neut.root ]; then
   rm -f fort.77 SK.card

   PrepareNEUT -i SK.neut.root \
               -f ${FLUX_FILE},${FLUX_HIST} -G
else
   echo "Failed to produce expected output file: SK.neut.root"
   exit 1
fi