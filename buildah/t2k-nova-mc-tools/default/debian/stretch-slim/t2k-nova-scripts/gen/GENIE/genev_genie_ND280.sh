#!/bin/bash

if [ -z $1 ]; then
  echo "Please pass a number of events to generate."
  exit 1
fi

NEVS=$1

RUNNUM=${RANDOM}

if [ -e gntp.${RUNNUM}.ghep.root ]; then
   echo "Already have file: gntp.${RUNNUM}.ghep.root, not overwriting."
   exit 1
fi

if [ -e ND280.CH.prep.root ]; then
   echo "Already have file: ND280.CH.prep.root, not overwriting."
   exit 1
fi

gevgen \
   -p 14 -t ${CHTARGET} \
   -r ${RUNNUM} -e 0.1,10 \
   -f ${ND280FLUX_NUMODE_FILE},${ND280FLUX_NUMODE_HIST} \
   -n ${NEVS} \
   --cross-sections ${GENIE_XSEC_FILE} \
   --event-generator-list Default+MEC \
   --message-thresholds Messenger_whisper.xml

if [ -e gntp.${RUNNUM}.ghep.root ]; then
   rm -f input-flux.root
   rm -f genie-mcjob-${RUNNUM}.status

   mv gntp.${RUNNUM}.ghep.root ND280.CH.prep.root
   PrepareGENIE -i ND280.CH.prep.root \
               -f ${ND280FLUX_NUMODE_FILE},${ND280FLUX_NUMODE_HIST} \
               -t ${CHTARGET}
else
   echo "Failed to produce expected output file: gntp.${RUNNUM}.ghep.root"
   exit 1
fi
