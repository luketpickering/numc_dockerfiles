#!/bin/bash

if [ -z $1 ]; then
  echo "Please pass a number of events to generate."
  exit 1
fi

NEVS=$1

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

RUNNUM=${RANDOM}

if [ -e gntp.${RUNNUM}.ghep.root ]; then
   echo "Already have file: gntp.${RUNNUM}.ghep.root, not overwriting."
   exit 1
fi

if [ -e SK.H2O.${BEAMMODE}.${RUNNUM}.prep.root ]; then
   echo "Already have file: SKSK.H2O.${BEAMMODE}.${RUNNUM}.prep.root, not overwriting."
   exit 1
fi

echo "RUN Number: ${RUNNUM}" 
gevgen \
   -p ${NU_PDG} -t ${H2OTARGET} \
   -r ${RUNNUM} -e 0.1,10 \
   -f ${FLUX_FILE},${FLUX_HIST} \
   -n ${NEVS} --seed ${RUNNUM} \
   --cross-sections ${GENIE_XSEC_FILE} \
   --tune ${GENIE_XSEC_TUNE} \
   --event-generator-list Default \
   --message-thresholds Messenger_whisper.xml


if [ -e gntp.${RUNNUM}.ghep.root ]; then
   rm -f input-flux.root
   rm -f genie-mcjob-${RUNNUM}.status

   mv gntp.${RUNNUM}.ghep.root SK.H2O.${BEAMMODE}.${RUNNUM}.prep.root
   PrepareGENIE -i SK.H2O.${BEAMMODE}.${RUNNUM}.prep.root \
               -f ${FLUX_FILE},${FLUX_HIST} \
               -t ${H2OTARGET}
else
   echo "Failed to produce expected output file: gntp.${RUNNUM}.ghep.root"
   exit 1
fi
