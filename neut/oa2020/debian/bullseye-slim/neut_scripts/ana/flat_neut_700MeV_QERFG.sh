#!/bin/bash

if ! echo "${BASH_SOURCE}" | grep "/" --silent; then
  SETUPDIR=$(readlink -f $PWD)
else
  SETUPDIR=$(readlink -f ${BASH_SOURCE%/*})
fi

root -l -b -q "${SETUPDIR}/neutsummarytree.C+(\"RFG.CCQE.700MeV.numu.vect.root\",\"RFG.CCQE.700MeV.numu.flat.root\")"