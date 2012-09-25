#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME
sh autogen.sh
mkdir -p build
cd build
PKG_CONFIG_PATH=$LUNA_STAGING/lib/pkgconfig \
../configure --prefix=$LUNA_STAGING --enable-shared --disable-static
make -j$PROCCOUNT all
make install
