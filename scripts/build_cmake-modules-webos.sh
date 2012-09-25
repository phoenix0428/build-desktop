#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME
mkdir -p BUILD
cd BUILD
$CMAKE .. -DCMAKE_INSTALL_PREFIX=${BASE}/cmake
make
mkdir -p $BASE/cmake
make install

