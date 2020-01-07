#!/bin/bash

GEN=$1
INPF=$2
IS_POSTFIT=$3
ACC_FILE=${NOVANDACCEPT_FILE}
ACC_HIST_Q0Q3=${NOVANDACCEPT_HIST_Q0Q3}
ACC_HIST_PTHETA=${NOVANDACCEPT_HIST_PTHETA}
ACC_HIST_ENUY=${NOVANDACCEPT_HIST_ENUY}

if [ -z $GEN ] || ( [ ! ${GEN} = "GENIE" ] && [ ! ${GEN} = "NEUT" ] ); then
  echo "Please pass an generator as the first argument (GENIE/NEUT)."
  exit 1
fi

if [ -z $INPF ] || [ ! -e $INPF ]; then
  echo "Please pass an input file to read."
  exit 1
fi

if [ -z $IS_POSTFIT ]; then
  IS_POSTFIT=0
fi

#if it was sourced as . setup.sh then you can't scrub off the end... assume that
#we are in the correct directory.
if ! echo "${BASH_SOURCE}" | grep "/" --silent; then
  SETUPDIR=$(readlink -f $PWD)
else
  SETUPDIR=$(readlink -f ${BASH_SOURCE%/*})
fi

CARDNAME="NOvAND.prefit.${GEN}"
PREFIT_NOMINAL="nominal"
POSTFIT_NOMINAL="postfit"
if [ "$IS_POSTFIT" = "1" ]; then
  CARDNAME="NOvAND.postfit.${GEN}"
  PREFIT_NOMINAL="prefit"
  POSTFIT_NOMINAL="nominal"
fi

BASECARD=ND280Fit.card.stub
if [ ${GEN} == "GENIE" ]; then
  BASECARD=NOvA2019.card.stub
fi

cp ${SETUPDIR}/${BASECARD} ${CARDNAME}.cfg
for i in GEN \
         INPF \
         PREFIT_NOMINAL \
         POSTFIT_NOMINAL \
         ACC_FILE \
         ACC_HIST_Q0Q3 \
         ACC_HIST_PTHETA \
         ACC_HIST_ENUY; do
  sed -i "s|__${i}__|${!i}|g" ${CARDNAME}.cfg
done
mv ${CARDNAME}.cfg ${CARDNAME}.card

nuiscomp -c ${CARDNAME}.card -o ${CARDNAME}.flat.root
