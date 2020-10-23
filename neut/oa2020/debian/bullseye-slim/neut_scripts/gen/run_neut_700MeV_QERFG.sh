#!/bin/bash

if [ -z $1 ]; then
  echo "[ERROR]: Expected to be passed nevents to generate"
  exit 1
fi

if ! echo "${BASH_SOURCE}" | grep "/" --silent; then
  SETUPDIR=$(readlink -f $PWD)
else
  SETUPDIR=$(readlink -f ${BASH_SOURCE%/*})
fi

NEUTTMPDIR=/tmp/neut_run${RANDOM}
mkdir -p ${NEUTTMPDIR}

cp ${SETUPDIR}/RFG.700MeV.card ${NEUTTMPDIR}/

cd ${NEUTTMPDIR}
cp ${NEUT_CRSDAT}/*.dat .

sed -i "s/__NEVENTS__/$1/g" RFG.700MeV.card

neutroot2 RFG.700MeV.card &> /dev/null

mv neutvect.root $OLDPWD/RFG.CCQE.700MeV.numu.vect.root

rm -rf ${NEUTTMPDIR}