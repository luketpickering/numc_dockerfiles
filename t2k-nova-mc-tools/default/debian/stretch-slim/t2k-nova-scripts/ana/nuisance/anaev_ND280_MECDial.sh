#!/bin/bash

GEN=$1
INPF=$2
IS_QELIKE=$3
ACC_FILE=${ND280ACCEPT_FILE}
ACC_HIST_Q0Q3=${ND280ACCEPT_HIST_Q0Q3}
ACC_HIST_PTHETA=${ND280ACCEPT_HIST_PTHETA}
ACC_HIST_ENUY=${ND280ACCEPT_HIST_ENUY}

if [ -z $GEN ] || ( [ ! ${GEN} = "GENIE" ] && [ ! ${GEN} = "NEUT" ] ); then
  echo "Please pass an generator as the first argument (NEUT)."
  exit 1
fi

if [ -z $INPF ] || [ ! -e $INPF ]; then
  echo "Please pass an input file to read."
  exit 1
fi

if [ -z $IS_QELIKE ]; then
  IS_QELIKE=0
fi

#if it was sourced as . setup.sh then you can't scrub off the end... assume that
#we are in the correct directory.
if ! echo "${BASH_SOURCE}" | grep "/" --silent; then
  SETUPDIR=$(readlink -f $PWD)
else
  SETUPDIR=$(readlink -f ${BASH_SOURCE%/*})
fi

CARDNAME="ND280.RESLike.${GEN}"
if [ ${GEN} == "GENIE" ]; then
  BASECARD=NOvAMECRESLike.card.stub
else
  BASECARD=ND280FitMECNievesLike.card.stub
fi

if [ "$IS_QELIKE" = "1" ]; then
  CARDNAME="ND280.QELike.${GEN}"
  if [ ${GEN} == "GENIE" ]; then
    BASECARD=NOvAMECQELike.card.stub
  else
    BASECARD=ND280FitMECQELike.card.stub
  fi
fi

cp ${SETUPDIR}/${BASECARD} ${CARDNAME}.cfg
for i in GEN \
         INPF \
         ACC_FILE \
         ACC_HIST_Q0Q3 \
         ACC_HIST_PTHETA \
         ACC_HIST_ENUY; do
  sed -i "s|__${i}__|${!i}|g" ${CARDNAME}.cfg
done
mv ${CARDNAME}.cfg ${CARDNAME}.card

nuiscomp -c ${CARDNAME}.card -o ${CARDNAME}.flat.root
