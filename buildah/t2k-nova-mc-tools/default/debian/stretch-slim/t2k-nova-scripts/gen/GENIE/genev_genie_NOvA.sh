#!/bin/bash

if [ -z $1 ]; then
  echo "Please pass a number of events to generate."
  exit 1
fi

NEVS=$1

RUNUM=${RANDOM}

gevgen \
   -p 14 -t ${NOVASOUP} \
   -r ${RUNUM} -e 0.1,20 \
   -f ${NOVANDFLUX_NUMODE_FILE},${NOVANDFLUX_NUMODE_HIST} \
   -n ${NEVS} \
   --cross-sections ${GENIE_XSEC_DIR}/gxspl-FNALsmall.xml.gz \
   --event-generator-list Default+MEC \
   --message-thresholds Messenger_whisper.xml

if [ -e gntp.${RUNUM}.ghep.root ]; then
   rm -f input-flux.root
   rm -f genie-mcjob-${RUNUM}.status

   mv gntp.${RUNUM}.ghep.root NOvAND.Soup.prep.root
   PrepareGENIE -i NOvAND.Soup.prep.root \
               -f ${NOVANDFLUX_NUMODE_FILE},${NOVANDFLUX_NUMODE_HIST} \
               -t ${NOVASOUP}
else
   echo "Failed to produce expected output file: gntp.${RUNUM}.ghep.root"
   exit 1
fi