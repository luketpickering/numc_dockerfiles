#!/bin/bash

if [ -z $1 ]; then
  echo "Please pass a number of events to generate."
  exit 1
fi

NEVS=$1

RUNUM=${RANDOM}

gevgen \
   -p 14 -t ${H2OTARGET} \
   -r ${RUNUM} -e 0.1,10 \
   -f ${SKFLUX_NUMODE_FILE},${SKFLUX_NUMODE_HIST} \
   -n ${NEVS} \
   --cross-sections ${GENIE_XSEC_DIR}/gxspl-FNALsmall.xml.gz \
   --event-generator-list Default+MEC \
   --message-thresholds Messenger_whisper.xml


if [ -e gntp.${RUNUM}.ghep.root ]; then
   rm -f input-flux.root
   rm -f genie-mcjob-${RUNUM}.status

   mv gntp.${RUNUM}.ghep.root SK.H2O.prep.root
   PrepareGENIE -i SK.H2O.prep.root \
               -f ${SKFLUX_NUMODE_FILE},${SKFLUX_NUMODE_HIST} \
               -t ${H2OTARGET}
else
   echo "Failed to produce expected output file: gntp.${RUNUM}.ghep.root"
   exit 1
fi