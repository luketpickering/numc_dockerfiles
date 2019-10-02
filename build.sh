#!/bin/bash

cd root/6/debian/stretch
./build.sh OFF
if [ $? != 0 ]; then exit 1; fi
./build.sh ON
if [ $? != 0 ]; then exit 1; fi

cd -

cd neut/533/debian/stretch
./build.sh
if [ $? != 0 ]; then exit 1; fi

cd -

cd neut/540/debian/stretch
./build.sh
if [ $? != 0 ]; then exit 1; fi

cd -

cd T2KReWeight/debian/stretch
./build.sh
if [ $? != 0 ]; then exit 1; fi

cd -

cd GENIE/2_12_2/debian/stretch
./build.sh
if [ $? != 0 ]; then exit 1; fi

cd -

cd GENIE/3_00_06/debian/stretch
./build.sh
if [ $? != 0 ]; then exit 1; fi

cd -

cd GiBUU/debian/stretch
./build.sh
if [ $? != 0 ]; then exit 1; fi

cd -

cd nuisance/debian/stretch
./build.sh
if [ $? != 0 ]; then exit 1; fi

cd -

cd NOvAReWeight/debian/stretch
./build.sh
if [ $? != 0 ]; then exit 1; fi

cd -

cd t2k-nova-mc-tools/debian/stretch
./build.sh
if [ $? != 0 ]; then exit 1; fi

cd -

docker push picker24/root_6_12_6:debian_stretch
docker tag picker24/root_6_12_6:debian_stretch picker24/root_6_12_6:latest
docker push picker24/root_6_12_6:lates

docker push picker24/cernlib2005:debian_stretch
docker tag picker24/cernlib2005:debian_stretch picker24/cernlib2005:latest
docker push picker24/cernlib2005:latest

docker push picker24/neut533:debian_stretch
docker tag picker24/neut533:debian_stretch picker24/neut533:latest
docker push picker24/neut533:latest

docker push picker24/neut540:debian_stretch
docker tag picker24/neut540:debian_stretch picker24/neut540:latest
docker push picker24/neut540:latest

docker push picker24/t2kreweight_v1r27p3:debian_stretch
docker tag picker24/t2kreweight_v1r27p3:debian_stretch picker24/t2kreweight_v1r27p3:latest
docker push picker24/t2kreweight_v1r27p3:latest

docker push picker24/genie_2_12_2:debian_stretch
docker tag picker24/genie_2_12_2:debian_stretch picker24/genie_2_12_2:latest
docker push picker24/genie_2_12_2:latest

docker push picker24/genie_3_00_06:debian_stretch
docker tag picker24/genie_3_00_06:debian_stretch picker24/genie_3_00_06:latest
docker push picker24/genie_3_00_06:latest

docker push picker24/gibuu_2019:debian_stretch
docker tag picker24/gibuu_2019:debian_stretch picker24/gibuu_2019:latest
docker push picker24/gibuu_2019:latest

docker push picker24/nuisance:debian_stretch
docker tag picker24/nuisance:debian_stretch picker24/nuisance:latest
docker push picker24/nuisance:latest