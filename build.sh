#!/bin/bash

# cd pythia/debian/stretch
# ./build.sh
# if [ $? != 0 ]; then exit 1; fi

# cd -

# cd root/6/debian/stretch
# ./build.sh OFF
# if [ $? != 0 ]; then exit 1; fi
# ./build.sh ON
# if [ $? != 0 ]; then exit 1; fi

# cd -

# cd root/5/centos/6
# ./build.sh
# if [ $? != 0 ]; then exit 1; fi

# cd -

# cd neut/540/debian/stretch
# ./build.sh
# if [ $? != 0 ]; then exit 1; fi

# cd -

# cd lhapdf/debian/stretch
# ./build.sh
# if [ $? != 0 ]; then exit 1; fi

# cd -

# cd GENIE/2_12_2/debian/stretch
# ./build.sh
# if [ $? != 0 ]; then exit 1; fi

# cd -

# cd GENIE/3_00_06/debian/stretch
# ./build.sh
# if [ $? != 0 ]; then exit 1; fi

# cd -

# cd GiBUU/debian/stretch
# ./build.sh
# if [ $? != 0 ]; then exit 1; fi

# cd -

# cd NOvAReWeight/debian/stretch
# ./build.sh
# if [ $? != 0 ]; then exit 1; fi

# cd -

# cd cernlib/debian/stretch
# ./build.sh
# if [ $? != 0 ]; then exit 1; fi

# cd -

cd neut/533/debian/stretch
./build.sh
if [ $? != 0 ]; then exit 1; fi

cd -

cd T2KReWeight/debian/stretch
./build.sh
if [ $? != 0 ]; then exit 1; fi

cd -

cd nuisance/debian/stretch
./build.sh
if [ $? != 0 ]; then exit 1; fi

cd -

cd t2k-nova-mc-tools/debian/stretch
./build.sh
if [ $? != 0 ]; then exit 1; fi

cd -

cd cernlib/centos/6
./build.sh
if [ $? != 0 ]; then exit 1; fi

cd -

cd neut/533/centos/6
./build.sh
if [ $? != 0 ]; then exit 1; fi

cd -

