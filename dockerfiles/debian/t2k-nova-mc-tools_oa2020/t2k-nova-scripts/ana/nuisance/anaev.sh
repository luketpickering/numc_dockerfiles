#!/bin/bash

GEN=""
INPF=""
TUNE=""
declare -a DIALNAMES
declare -A DIALTWEAKS
declare -a EXTRADIALTWEAKS
declare -A DIALTYPES
BRANCHNAME=""
OUTFILE=""
NMAX=""
NSKIP=""
PROBE=""

TARGET=""

while [[ ${#} -gt 0 ]]; do

  key="$1"
  case $key in

      -g|--generator)

      if [[ ${#} -lt 2 ]]; then
        echo "[ERROR]: ${1} expected a value."
        exit 1
      fi

      GEN="$2"
      echo "[OPT]: Using generator ${GEN}"
      shift # past argument
      ;;

      -i|--input)

      if [[ ${#} -lt 2 ]]; then
        echo "[ERROR]: ${1} expected a value."
        exit 1
      fi

      INPF="$2"
      echo "[OPT]: Reading events from ${INPF}"
      shift # past argument
      ;;

      -o|--output)

      if [[ ${#} -lt 2 ]]; then
        echo "[ERROR]: ${1} expected a value."
        exit 1
      fi

      OUTFILE="$2"
      echo "[OPT]: Writing flat tree to ${OUTFILE}"
      shift # past argument
      ;;

      -n|--nmax)

      if [[ ${#} -lt 2 ]]; then
        echo "[ERROR]: ${1} expected a value."
        exit 1
      fi

      NMAX="$2"
      echo "[OPT]: Processing at most ${NMAX}"
      shift # past argument
      ;;

      -s|--skip)

      if [[ ${#} -lt 2 ]]; then
        echo "[ERROR]: ${1} expected a value."
        exit 1
      fi

      NSKIP="$2"
      echo "[OPT]: Skipping the first ${NSKIP} events from the file"
      shift # past argument
      ;;


      -T|--tune)

      if [[ ${#} -lt 2 ]]; then
        echo "[ERROR]: ${1} expected a value."
        exit 1
      fi

      TUNE="$2"
      echo "[OPT]: Tuning with: ${TUNE}"
      shift # past argument
      ;;

      -t|--target)

      if [[ ${#} -lt 2 ]]; then
        echo "[ERROR]: ${1} expected a value."
        exit 1
      fi

      TARGET="$2"
      echo "[OPT]: Tuning ${TARGET}-target events"
      shift # past argument
      ;;

      -AT|--available-tunes)

      echo -e "T2K (NEUT):"
      echo -e "\tBANFF_PRE"
      echo -e "\tBANFF_POST"

      echo -e "NOvA (GENIE):"
      echo -e "\t2020"

      exit 0
      ;;

      -P|--probe)

      if [[ ${#} -lt 2 ]]; then
        echo "[ERROR]: ${1} expected a value."
        exit 1
      fi

      PROBE="$2"
      echo "[OPT]: Using: ${2} as probe"
      shift # past argument
      ;;

      -d|--dial-tweak)

      if [[ ${#} -lt 2 ]]; then
        echo "[ERROR]: ${1} expected a value."
        exit 1
      fi

      EXTRADIALTWEAKS+=("${2}")
      echo "[OPT]: Tweaking dial: ${2}"
      shift # past argument
      ;;

      -b|--branchname)

      if [[ ${#} -lt 2 ]]; then
        echo "[ERROR]: ${1} expected a value."
        exit 1
      fi

      BRANCHNAME="${2}"
      echo "[OPT]: Writing weight branch only ${BRANCHNAME}"
      shift # past argument
      ;;


    -?|--help)
              # unknown option
      echo "Arguments:"
      echo -e "\tRequired:"
      echo -e "\t  -g|--generator <NEUT/GENIE>"
      echo -e "\t  -i|--input </path/to/input.root>"
      echo -e "\t  -t|--targed <CH|H2O>"
      echo -e "\t  -P|--probe <nu[mu,e][,bar]>"
      echo -e "\Optional:"
      echo -e "\t  -o|--output </path/to/output.root>"
      echo -e "\t  -n|--nmax <max evs to process>"
      echo -e "\t  -s|--skip <leading evs to skip>"
      echo -e "\t  -T|--tune <Tune Name>"
      echo -e "\t  -AT|--available-tunes    : Print available tunes"
      echo -e "\t  -d|--dial-tweak <Name,Value,dial_type>"
      echo -e "\t  -b|--branchname          : Do not write full kinematic tree,"
      echo -e "\t                             just the tune weight branch to be "
      echo -e "\t                             used as a friend tree."
      echo -e "\t  -?|--help"
      exit 0
      ;;


      *)
              # unknown option
      echo "Unknown option $1"
      exit 1
      ;;
  esac
  shift # past argument or value
done

if [ -z $GEN ] || ( [ ! ${GEN} = "GENIE" ] && [ ! ${GEN} = "NEUT" ] ); then
  echo "Please pass an generator (GENIE/NEUT) with the -g option."
  exit 1
fi


if [ -z $TARGET ] || ( [ ! ${TARGET} = "CH" ] && [ ! ${TARGET} = "H2O" ] ); then
  echo "Please pass a target-nucleus with the -t option."
  exit 1
fi

if [ -z $PROBE ]; then
  echo "Please pass a probe (nu[mu,e][,bar]) with the -P option."
  exit 1
fi

if [ -z $INPF ] || [ ! -e $INPF ]; then
  echo "Please pass an input file to read with the -i option."
  exit 1
fi

# Table of dials <NAME>,<VALUE>,<TYPE>
BANFF_PRE=(

"NXSec_MaCCQE,-0.8999980011,t2k_parameter"

"NIWGMEC_PDDWeight_C12,-21.25,t2k_parameter"
"NIWGMEC_PDDWeight_O16,-26.66666667,t2k_parameter"

"NXSec_CA5RES,-0.2000002004,t2k_parameter"
"NXSec_MaRES,0.8000266659,t2k_parameter"
"NXSec_BgSclRES,-1.699996998,t2k_parameter"
"NXSec_UseSeparateBgSclLMCPiBar,1,t2k_parameter"
"NXSec_BgSclLMCPiBarRES,-0.5666656661,t2k_parameter"

)

BANFF_POST=(

"NXSec_MaCCQE,-0.1883849002,t2k_parameter"

"NIWGQETwk_LowQ2Suppression1,0.784189,t2k_parameter"
"NIWGQETwk_LowQ2Suppression2,0.886824,t2k_parameter"
"NIWGQETwk_LowQ2Suppression3,1.02287,t2k_parameter"
"NIWGQETwk_LowQ2Suppression4,1.02686,t2k_parameter"
"NIWGQETwk_LowQ2Suppression5,1.08673,t2k_parameter"
"NIWGQETwk_LowQ2Suppression6,1.25683,t2k_parameter"
"NIWGQETwk_LowQ2Suppression7,1.13608,t2k_parameter"
"NIWGQETwk_LowQ2Suppression8,1.25937,t2k_parameter"

"NIWGMEC_PDDWeight_C12,-0.70182375,t2k_parameter"
"NIWGMEC_PDDWeight_O16,-26.75522027,t2k_parameter"

"NXSec_CA5RES,-0.1052339202,t2k_parameter"
"NXSec_MaRES,-1.073271999,t2k_parameter"
"NXSec_BgSclRES,-2.174607498,t2k_parameter"
"NXSec_UseSeparateBgSclLMCPiBar,1,t2k_parameter"
"NXSec_BgSclLMCPiBarRES,-0.5666656661,t2k_parameter"

"NIWG_DIS_BY,1.04153,t2k_parameter"
"NIWG_MultiPi_BY,-0.0319243,t2k_parameter"
"NIWG_MultiPi_Xsec_AGKY,0.139487,t2k_parameter"

#CC_COH
"mode_16,0.609,modenorm_parameter"
#NC_COH
"mode_36,1.018,modenorm_parameter"

#NC_other_near
"mode_41,1.662,modenorm_parameter"
"mode_42,1.662,modenorm_parameter"
"mode_43,1.662,modenorm_parameter"
"mode_44,1.662,modenorm_parameter"
"mode_45,1.662,modenorm_parameter"
"mode_46,1.662,modenorm_parameter"

#CC_Misc
"mode_17,2.27764,modenorm_parameter"
"mode_22,2.27764,modenorm_parameter"
"mode_23,2.27764,modenorm_parameter"

"NCasc_FrInelLow_pi,-0.34744,t2k_parameter"
"NCasc_FrInelHigh_pi,-0.8403433333,t2k_parameter"
"NCasc_FrPiProd_pi,1.42996,t2k_parameter"
"NCasc_FrAbs_pi,0.38086,t2k_parameter"
"NCasc_FrCExLow_pi,-0.445892,t2k_parameter"

)

BANFF_POST_C_NU=(

#nu C
"mode_2,1.05805,modenorm_parameter"

#nu
"mode_26,1.0616,modenorm_parameter"
"mode_21,1.0616,modenorm_parameter"

)
BANFF_POST_O_NU=(

#nu O C*1.04647
"mode_2,1.05805,modenorm_parameter"

#nu
"mode_26,1.0616,modenorm_parameter"
"mode_21,1.0616,modenorm_parameter"

)
BANFF_POST_C_NUB=(

#nub C
"mode_2,0.721673,modenorm_parameter"

#nub
"mode_26,0.935022,modenorm_parameter"
"mode_21,0.935022,modenorm_parameter"

)
BANFF_POST_O_NUB=(

#nub O C*1.04647
"mode_2,1.107217,modenorm_parameter"

#nub
"mode_26,0.935022,modenorm_parameter"
"mode_21,0.935022,modenorm_parameter"

)

NOvA2020=(
  "CVTune2020,1,nova_parameter"
)

CHOSEN_TUNE=()
NEUT_CARD=""

if [ ! -z $TUNE ]; then

  if [ ${GEN} == "GENIE" ]; then
    if [ ${TUNE} == "2020" ]; then      
      CHOSEN_TUNE=${NOvA2020[@]}
    else
      echo "Invalid NOvA Tune selected. Only \"2020\" available."
      exit 1
    fi
  fi

  if [ ${GEN} == "NEUT" ]; then
    if  [ ${TUNE} == "BANFF_PRE" ]; then
      CHOSEN_TUNE=${BANFF_PRE[@]}
      NEUT_CARD="/var/t2k-nova/scripts/ana/nuisance/cards/NEUT_14_C.card"
    elif  [ ${TUNE} == "BANFF_POST" ]; then
        CHOSEN_TUNE=${BANFF_POST[@]}
        if [ ${PROBE} == "numu" ]; then
          if [ ${TARGET} == "CH" ]; then
            for d in ${BANFF_POST_C_NU[@]}; do
              CHOSEN_TUNE+=( ${d} )
            done
            NEUT_CARD="/var/t2k-nova/scripts/ana/nuisance/cards/NEUT_14_C.card"
          else
            for d in ${BANFF_POST_O_NU[@]}; do
              CHOSEN_TUNE+=( ${d} )
            done
            NEUT_CARD="/var/t2k-nova/scripts/ana/nuisance/cards/NEUT_14_O.card"
          fi
        elif [ ${PROBE} == "nue" ]; then
          if [ ${TARGET} == "CH" ]; then
            for d in ${BANFF_POST_C_NU[@]}; do
              CHOSEN_TUNE+=( ${d} )
            done
            NEUT_CARD="/var/t2k-nova/scripts/ana/nuisance/cards/NEUT_12_C.card"
          else
            for d in ${BANFF_POST_O_NU[@]}; do
              CHOSEN_TUNE+=( ${d} )
            done
            NEUT_CARD="/var/t2k-nova/scripts/ana/nuisance/cards/NEUT_12_O.card"
          fi
        elif [ ${PROBE} == "numubar" ]; then
          if [ ${TARGET} == "CH" ]; then
            for d in ${BANFF_POST_C_NUB[@]}; do
              CHOSEN_TUNE+=( ${d} )
            done
            NEUT_CARD="/var/t2k-nova/scripts/ana/nuisance/cards/NEUT_-14_C.card"
          else
            for d in ${BANFF_POST_O_NUB[@]}; do
              CHOSEN_TUNE+=( ${d} )
            done
            NEUT_CARD="/var/t2k-nova/scripts/ana/nuisance/cards/NEUT_-14_O.card"
          fi
        elif [ ${PROBE} == "nuebar" ]; then
          if [ ${TARGET} == "CH" ]; then
            for d in ${BANFF_POST_C_NUB[@]}; do
              CHOSEN_TUNE+=( ${d} )
            done
            NEUT_CARD="/var/t2k-nova/scripts/ana/nuisance/cards/NEUT_-12_C.card"
          else
            for d in ${BANFF_POST_O_NUB[@]}; do
              CHOSEN_TUNE+=( ${d} )
            done
            NEUT_CARD="/var/t2k-nova/scripts/ana/nuisance/cards/NEUT_-12_O.card"
          fi
        else 
          echo "Invalid probe: ${PROBE}, for tune: ${TUNE}"
          exit 1
        fi
      
      
    else
      echo "Invalid T2K Tune selected. Try one of:"
      echo -e "\tBANFF_PRE"
      echo -e "\tBANFF_POST"
      exit 1
    fi
  
  if [[ -z "${NEUT_CARD}" ]]; then
    echo "[ERROR]: Failed to select NEUT card file: PROBE: ${PROBE}, TUNE: ${TUNE}."
    exit 1
  fi

  fi

fi

for i in ${CHOSEN_TUNE[@]}; do
  OLD_IFS=${IFS}
  IFS=","

  set -- ${i}

  PAR_NAME=${1}
  PAR_VAL=${2}
  PAR_TYPE=${3}

  DIALTWEAKS[${PAR_NAME}]=${PAR_VAL}
  DIALTYPES[${PAR_NAME}]=${PAR_TYPE}
  DIALNAMES+=(${PAR_NAME})

  IFS=${OLD_IFS}  
done

for i in ${EXTRADIALTWEAKS[@]}; do
  OLD_IFS=${IFS}
  IFS=","

  set -- ${i}

  PAR_NAME=${1}
  PAR_VAL=${2}
  PAR_TYPE=${3}

  if [[ " ${DIALNAMES[@]} " =~ " ${PAR_NAME} " ]]; then
    DIALTWEAKS[${PAR_NAME}]=${PAR_VAL}
  else
    if [ -z ${PAR_TYPE} ]; then
      echo "Adding new parameter: {PAR_NAME} but type is not specified, use like -d <name>,<value>,<type>."
      exit 1
    fi
    DIALTWEAKS[${PAR_NAME}]=${PAR_VAL}
    DIALTYPES[${PAR_NAME}]=${PAR_TYPE}
    DIALNAMES+=(${PAR_NAME})
  fi

  IFS=${OLD_IFS}  
done

#if it was sourced as . setup.sh then you can't scrub off the end... assume that
#we are in the correct directory.
if ! echo "${BASH_SOURCE}" | grep "/" --silent; then
  SETUPDIR=$(readlink -f $PWD)
else
  SETUPDIR=$(readlink -f ${BASH_SOURCE%/*})
fi

if [ ! -z $TUNE ]; then
  CARDNAME="T2KNOvAFlat.${GEN}.nupdg_${PROBE}.${TUNE}.card"
else
  CARDNAME="T2KNOvAFlat.${GEN}.nupdg_${PROBE}.Nominal.card"
fi

if [ -z ${OUTFILE} ]; then
  OUTFILE=${CARDNAME}.nupdg_${PROBE}.flat.root
fi

if [ -e ${OUTFILE} ]; then
  OUTFILE=${OUTFILE%%.root}.${RANDOM}.root
fi

echo -e "<nuisance>" > ${CARDNAME}

if [ ${GEN} == "GENIE" ]; then
  echo -e "\t<config GENIETune=\"${GENIE_XSEC_TUNE}\" />" >> ${CARDNAME}
fi
if [ ${GEN} == "NEUT" ]; then
  echo -e "\t<config NEUT_CARD=\"${NEUT_CARD}\" />" >> ${CARDNAME}
fi

echo -en "\t<sample name=\"T2KNOvAFlatTree\" input=\"${GEN}:${INPF}\"" >> ${CARDNAME}

if [ ! -z ${BRANCHNAME} ]; then
  echo -en " weight_friend_name=\"${BRANCHNAME}\"" >> ${CARDNAME}
fi

echo -e " />" >> ${CARDNAME}

for i in "${DIALNAMES[@]}"; do
 
  echo -e "\t<parameter name=\"${i}\" nominal=\"${DIALTWEAKS[$i]}\" type=\"${DIALTYPES[$i]}\" />" >> ${CARDNAME}

done

echo -e "</nuisance>" >> ${CARDNAME}


EXTRA_OPTS=""
if [ ! -z ${NMAX} ]; then
  EXTRA_OPTS="${EXTRA_OPTS} -n ${NMAX}"
fi
if [ ! -z ${NSKIP} ]; then
  EXTRA_OPTS="${EXTRA_OPTS} -s ${NSKIP}"
fi

nuiscomp -c ${CARDNAME} ${EXTRA_OPTS} -o ${OUTFILE}
