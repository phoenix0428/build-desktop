#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME

export QMAKE=$LUNA_STAGING/bin/qmake-palm
export QMAKEPATH=$WEBKIT_DIR/Tools/qmake
$LUNA_STAGING/bin/qmake-palm
make -j$PROCCOUNT -f Makefile
make -f Makefile install
