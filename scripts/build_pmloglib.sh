#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

mkdir -p $BASE/$NAME/build
cd $BASE/$NAME/build

$CMAKE .. -DNO_TESTS=True -DNO_UTILS=True -DCMAKE_INSTALL_PREFIX=${LUNA_STAGING} -DCMAKE_BUILD_TYPE=Release
make -j$PROCCOUNT
make install
