#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME

export QTDIR=$BASE/qt-build-desktop
export QMAKE=$LUNA_STAGING/bin/qmake-palm
export QMAKEPATH=$WEBKIT_DIR/Tools/qmake
export QT_INSTALL_PREFIX=$LUNA_STAGING
export STAGING_DIR=${LUNA_STAGING}
export STAGING_INCDIR="${LUNA_STAGING}/include"
export STAGING_LIBDIR="${LUNA_STAGING}/lib"
$LUNA_STAGING/bin/qmake-palm
make -j$PROCCOUNT -f Makefile
make -j$PROCCOUNT -e PREFIX=$LUNA_STAGING -f Makefile install BUILD_TYPE=release
