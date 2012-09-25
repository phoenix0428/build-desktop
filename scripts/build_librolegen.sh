#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME
mkdir -p build
cd build
$CMAKE -D WEBOS_INSTALL_ROOT:PATH=${LUNA_STAGING} -DCMAKE_INSTALL_PREFIX=${LUNA_STAGING} ..
make -j$PROCCOUNT
make install
