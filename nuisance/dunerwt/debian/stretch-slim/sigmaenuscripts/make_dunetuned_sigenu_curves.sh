#!/bin/bash

if [ -z $1 ]; then
  echo "Please pass a number of events to generate."
  exit 1
fi

if [ -z $2 ]; then
  echo "Please pass a neutrino probe pdg for events to generate."
  exit 1
fi

NEVS=$1
NU_PDG=$2

CONFIG_FILE=DUNETDRvfinal.CVOnly.ParamHeaders.fcl
EMIN=0
EMAX=10

while [[ ${#} -gt 2 ]]; do

  key="$3"
  case $key in

    --preTDRtune)

    CONFIG_FILE=DUNETDRv1.CVOnly.ParamHeaders.nocvmfs.fcl
    ;;

    --ERange)

    EMIN=${4}
    shift;
    EMAX=${4}
    shift;
    ;;
  
  esac
  shift # past argument or value
done

if [ -z $GENIE_XSEC_FILE ] || [ ! -e $GENIE_XSEC_FILE ]; then
  echo "Cannot find GENIE xsec file @ \$ENV{GENIE_XSEC_FILE}."
  exit 1
fi

echo "Generating events over range E=[${EMIN},${EMAX}]"

FLUX_FILE=flatflux_${EMIN}_${EMAX}GeV.root
FLUX_HIST=flux

RUNNUM=${RANDOM}

if [ -e gntp.${RUNNUM}.ghep.root ]; then
   echo "Already have file: gntp.${RUNNUM}.ghep.root, not overwriting."
   exit 1
fi

if [ -e Ar40.nu${NU_PDG}.prep.E_${EMIN}_${EMAX}GeV.root ]; then
   echo "Already have file: Ar40.nu${NU_PDG}.prep.E_${EMIN}_${EMAX}GeV.root, not overwriting."
   exit 1
fi

AR40TARGET="1000180400[1]"

#if it was sourced as . setup.sh then you can't scrub off the end... assume that
#we are in the correct directory.
if ! echo "${BASH_SOURCE}" | grep "/" --silent; then
  SETUPDIR=$(readlink -f $PWD)
else
  SETUPDIR=$(readlink -f ${BASH_SOURCE%/*})
fi

if [ ! -e ${FLUX_FILE} ]; then
  root -l -b -q "${SETUPDIR}/makeflatflux.C(\"${FLUX_FILE}\",${EMIN},${EMAX})"
fi

CMD="gevgen \
   -p ${NU_PDG} -t ${AR40TARGET} \
   -r ${RUNNUM} -e ${EMIN},${EMAX} \
   -f ${FLUX_FILE},${FLUX_HIST} \
   -n ${NEVS} --seed ${RUNNUM} \
   --cross-sections ${GENIE_XSEC_FILE} \
   --event-generator-list Default+MEC \
   --message-thresholds Messenger_whisper.xml"

echo $CMD
$CMD

if [ -e gntp.${RUNNUM}.ghep.root ]; then
   rm -f input-flux.root
   rm -f genie-mcjob-${RUNNUM}.status

   mv gntp.${RUNNUM}.ghep.root Ar40.nu${NU_PDG}.prep.E_${EMIN}_${EMAX}GeV.root
   PrepareGENIE -i Ar40.nu${NU_PDG}.prep.E_${EMIN}_${EMAX}GeV.root \
               -f ${FLUX_FILE},${FLUX_HIST} \
               -t ${AR40TARGET}
else
   echo "Failed to produce expected output file: gntp.${RUNNUM}.ghep.root"
   exit 1
fi

cat ${SETUPDIR}/geniedunerwtxsec.xml.in \
  | sed "s:__IFILE__:Ar40.nu${NU_PDG}.prep.E_${EMIN}_${EMAX}GeV.root:g" \
  | sed "s:__CONFIG_FCL__:$CONFIG_FILE:g" \
  > geniedunerwtxsec.xml

nuiscomp -c geniedunerwtxsec.xml -o Ar40.nu${NU_PDG}.E_${EMIN}_${EMAX}GeV.sigmaenu.root

rm geniedunerwtxsec.xml