#!/bin/bash

if [ -z $1 ]; then
  echo "Please pass an input ghep prep file."
  exit 1
fi

INPUTFILE=$1

CONFIG_FILE=DUNETDRvfinal.CVOnly.ParamHeaders.fcl
if [ $2 == "--preTDRtune" ]; then
  CONFIG_FILE=DUNETDRv1.CVOnly.ParamHeaders.nocvmfs.fcl
  shift;
fi

if [ $2 == "--binning" ]; then
  if [ -z $3 ] || [ -z $4 ] || [ -z $5 ] || [ -z $6 ]; then
    echo "Expected to be passed <nbins> <low_enu_gev> <up_enu_gev> <islogE=true/false>, but got \"$3\" \"$4\" \"$5\" \"$6\" "
    exit 1
  else
    NBINS=$3
    LOWBIN=$4
    UPBIN=$5
    ISLOGE=$6
  fi
else
    NBINS=100
    LOWBIN=0
    UPBIN=10
    ISLOGE=false
fi

if [ ! -e $INPUTFILE ]; then
   echo "Expect to find input file: $1, but couldn't."
   exit 1
fi

#if it was sourced as . setup.sh then you can't scrub off the end... assume that
#we are in the correct directory.
if ! echo "${BASH_SOURCE}" | grep "/" --silent; then
  SETUPDIR=$(readlink -f $PWD)
else
  SETUPDIR=$(readlink -f ${BASH_SOURCE%/*})
fi

cat ${SETUPDIR}/geniedunerwtxsec_custbinning.xml.in \
  | sed "s:__IFILE__:$INPUTFILE:g" \
  | sed "s:__NBINS__:$NBINS:g" \
  | sed "s:__LOWBIN__:$LOWBIN:g" \
  | sed "s:__UPBIN__:$UPBIN:g" \
  | sed "s:__ISLOGE__:$ISLOGE:g" \
  | sed "s:__CONFIG_FCL__:$CONFIG_FILE:g" \
  > geniedunerwtxsec_custbinning.xml

nuiscomp -c geniedunerwtxsec_custbinning.xml -o sigenu_custbinning.${INPUTFILE}

rm geniedunerwtxsec_custbinning.xml