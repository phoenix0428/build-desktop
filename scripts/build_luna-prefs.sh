#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME
make -j$PROCCOUNT
cp -d bin/lib/libluna-prefs.so* $LUNA_STAGING/lib
cp include/lunaprefs.h $LUNA_STAGING/include
