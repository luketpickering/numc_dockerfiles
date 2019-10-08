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

if [ -e NOvAND.Soup.prep.root ]; then
   echo "Already have file: NOvAND.Soup.prep.root, not overwriting."
   exit 1
fi

gevgen \
   -p 14 -t ${NOVASOUP} \
   -r ${RUNNUM} -e 0.1,20 \
   -f ${NOVANDFLUX_NUMODE_FILE},${NOVANDFLUX_NUMODE_HIST} \
   -n ${NEVS} \
   --cross-sections ${GENIE_XSEC_FILE} \
   --event-generator-list Default+MEC \
   --message-thresholds Messenger_whisper.xml

if [ -e gntp.${RUNNUM}.ghep.root ]; then
   rm -f input-flux.root
   rm -f genie-mcjob-${RUNNUM}.status

   mv gntp.${RUNNUM}.ghep.root NOvAND.Soup.prep.root
   PrepareGENIE -i NOvAND.Soup.prep.root \
               -f ${NOVANDFLUX_NUMODE_FILE},${NOVANDFLUX_NUMODE_HIST} \
               -t ${NOVASOUP}
else
   echo "Failed to produce expected output file: gntp.${RUNUM}.ghep.root"
   exit 1
fi
